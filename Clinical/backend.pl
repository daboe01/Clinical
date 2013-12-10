#!/usr/local/ActivePerl-5.14/site/bin/morbo

# todo: sanitize filenames upon upload
#		support multiple files of samename (as in cellfinder)
#		support shadowtables globally (instead of only in $table eq 'all_trials'?'trials': $table)

use lib qw {/Users/Shared/bin /Users/Shared/bin/Clinical /srv/www/Clinical/ /Users/boehringer/src/daboe01_Cellfinder/Cellfinder/ /Users/daboe01/src/daboe01_Cellfinder/Cellfinder /Users/boehringer/src/privatePerl /Users/daboe01/src/privatePerl};
use Mojolicious::Lite;
use Mojolicious::Plugin::Database;
use SQL::Abstract::More;
use Data::Dumper;
use Mojo::UserAgent;
use POSIX;
use Try::Tiny;
use TempFileNames;
use File::Find::Rule;
use Apache::Session::File;
use Net::LDAP;
use URI::Escape;
use JSON::XS;
use Mojolicious::Plugin::RenderFile;
use pdfgen;
use DateTime;

# enable receiving uploads up to 1GB
$ENV{MOJO_MAX_MESSAGE_SIZE} = 1_073_741_824;

plugin 'database', { 
			dsn	  => 'dbi:Pg:dbname=aug_clinical;user=root;host=auginfo',
			username => 'root',
			password => 'root',
			options  => { 'pg_enable_utf8' => 1, AutoCommit => 1 },
			helper   => 'db'
};
plugin 'RenderFile'; 


use constant doku_repo_path => '/Users/Shared/bin/Clinical/docrepo/';
use constant form_repo_path => '/Users/Shared/bin/Clinical/forms/';

#use constant doku_repo_path => '/Users/daboe01/src/daboe01_Clinicaltrials/Clinicaltrials/docrepo/';

###########################################
# "fake" tables for DBI interface

helper getLSDocuments => sub { my ($self)=@_;
	my $_docrepo= doku_repo_path;
	return	grep { defined $_->{idtrial} && $_->{tag} !~ /^\./ }
	map  { my ($p,$f)=split /\//o; ($f or '')=~/^([0-9]+)_(.+)/; {id=>"$1$2", idtrial=>$1, name=> $2, tag=>$p} }
	map  { s/^$_docrepo//ogs;$_}
	File::Find::Rule->in($_docrepo);
};

get '/CT/download/:idtrial/:name' => [idtrial=>qr/[0-9]+/, name=>qr/.+/] => sub {
	my $self=shift;
	my $idtrial=	$self->param("idtrial");
	my $name= $self->param("name");
	my $id	="$idtrial$name";
	my @doc=grep {$_->{id} eq $id} $self->getLSDocuments();
	my $format;
	$format=$1 if $name=~/\.([^\.]+)$/o;
	$self->render(data => TempFileNames::readFile(doku_repo_path . $doc[0]->{tag} .'/' . $idtrial.'_'. $name), format => $format );
};

get '/DBI/documents'=> sub
{	my $self = shift;
	$self->render( json=> $self->getLSDocuments() );
};
get '/DBI/doctags_catalogue'=> sub
{	my $self = shift;
	my %tags=();
	$tags{$_->{tag}}='' for $self->getLSDocuments();
	my @ret=  map {{name=>$_}} grep {length $_} (keys %tags);
	$self->render( json=> \@ret);
};
get '/DBI/documents/idtrial/:pk' => [pk=>qr/[a-z0-9\s]+/i] => sub
{	my $self = shift;
	my $pk  = $self->param('pk');
	my @dir= grep {$_->{idtrial} eq $pk} $self->getLSDocuments();
	$self->render( json=> \@dir );
};
# update docs
put '/DBI/documents/id/:key'=> [key=>qr/.+/] => sub
{	my $self	= shift;
	my $json_decoder= Mojo::JSON->new;
	my $jsonR   = $json_decoder->decode( $self->req->body );
	my $key		= $self->param('key');
	my @doc=grep {$_->{id} eq $key} $self->getLSDocuments();
	my $idtrial=$doc[0]->{idtrial};
	my $name=	$doc[0]->{name};
	my $oldname=doku_repo_path . $doc[0]->{tag} .'/' . $idtrial.'_'. $name;
	my $newname=$jsonR->{tag}?  doku_repo_path . $jsonR->{tag} .'/'  . $idtrial.'_'. $name:
								doku_repo_path . $doc[0]->{tag} .'/' . $idtrial.'_'. $jsonR->{name};
	rename $oldname, $newname;
	$self->render( json=> {err=> ''} );
};
# delete doc
del '/DBI/documents/id/:key'=> [key=>qr/.+/] => sub
{	my $self	= shift;
	my $key		= $self->param('key');
	
	my @doc=grep {$_->{id} eq $key} $self->getLSDocuments();
	my $idtrial=$doc[0]->{idtrial};
	my $name=	$doc[0]->{name};
	my $oldname=doku_repo_path . $doc[0]->{tag} .'/' . $idtrial.'_'. $name;
	unlink $oldname;
	$self->render( json=> {err=> ''} );
};

# POST /upload (push one or more files to app)
post '/upload/:idtrial' => [idtrial=>qr/[0-9]+/] => sub {
	my $self    = shift;
	my $idtrial=	$self->param("idtrial");
    my @uploads = $self->req->upload('files[]');
    for my $curr_upload (@uploads) {
		my $upload  = Mojo::Upload->new($curr_upload);
		my $bytes = $upload->slurp;
		my $filename=$upload->filename;
		$filename=~s/[^0-9a-z\-\. ']/_/ogsi;
		TempFileNames::writeFile(doku_repo_path.'Unclassified/'.$idtrial.'_'.$filename, $bytes);
    }
    $self->render( json => \@uploads );
};


###########################################
# generic dbi part

helper fetchFromTable => sub { my ($self, $table, $sessionid, $where)=@_;
	my $sql = SQL::Abstract::More->new;
	my $order_by=[];

	#	support table-specific autosorting via hash
	my $autosorting={
						trial_visits=>		[qw/+visit_interval/],
						patient_visits=>	[qw/+visit_date/]
					};

	my @a;
	if($sessionid)		# implement session-bound serverside security
	{	my  %session;
		tie %session, 'Apache::Session::File', $sessionid , {Transaction => 0};
		my @cols=qw/*/;
		if($table eq 'all_trials')
		{	$table = 'trials';
			@cols=qw/id idgroup name codename infotext global_state fulltext/;
			$where->{ldap}= $session{username} unless $session{username} eq 'daboe01';
		} elsif($table eq 'groups_catalogue')
		{	$table = 'groups';
			@cols=qw/id name sprechstunde/;
			$where->{ldap}= $session{username} unless $session{username} eq 'daboe01';
		} elsif($table eq 'trial_property_annotations')
		{	$where->{ldap}= $session{username};
		} elsif($table eq 'patient_visits')
		{	$table = 'patient_visits_rich';
			@cols=qw/id idpatient idvisit visit_date state lower_margin center_margin upper_margin missing_service/;
		}
		$order_by= $autosorting->{$table} if exists $autosorting->{$table};
		my($stmt, @bind) = $sql->select( -columns  => [-distinct => @cols], -from => $table, -where=> $where, -order_by=> $order_by);
		my $sth = $self->db->prepare($stmt);
		$sth->execute(@bind);
		
		while(my $c=$sth->fetchrow_hashref())
		{	push @a,$c;
		}
	}
	return \@a;
};

# fetch all entities
get '/DBI/:table'=> sub
{	my $self = shift;
	my $table  = $self->param('table');
	my $sessionid  = $self->param('session');
	my $res=$self->fetchFromTable($table, $sessionid, {});
	$self-> render( json => $res);
};

# fetch entities by (foreign) key
get '/DBI/:table/:col/:pk' => [col=>qr/[a-z_0-9\s]+/, pk=>qr/[a-z0-9\s\-]+/i] => sub
{	my $self = shift;
	my $table  = $self->param('table');
	my $pk  = $self->param('pk');
	my $col  = $self->param('col');
	my $sessionid  = $self->param('session');
	my $res=$self->fetchFromTable($table, $sessionid, {$col=> $pk});
	$self-> render( json => $res);
};

# update
put '/DBI/:table/:pk/:key'=> [key=>qr/\d+/] => sub
{	my $self	= shift;
	my $table	= $self->param('table');
	my $pk		= $self->param('pk');
	my $key		= $self->param('key');
	my $sql		= SQL::Abstract->new;
	my $json_decoder= Mojo::JSON->new;
	my $jsonR   = $json_decoder->decode( $self->req->body );
	app->log->debug($self->req->body);
	my($stmt, @bind) = $sql->update($table, $jsonR, {$pk=>$key});
	my $sth = $self->db->prepare($stmt);
	$sth->execute(@bind);
	app->log->debug("err: ".$DBI::errstr ) if $DBI::errstr;
	my $ret={err=> $DBI::errstr};

	if($table eq 'patients')	# autofetch stammdaten if a piz is spezified
	{
		if($jsonR->{piz})
		{
			my $ua = Mojo::UserAgent->new;
			my $data=$ua->get('http://auginfo/piz/'.$jsonR->{piz})->res->body;
			my $a=JSON::XS->new->utf8->decode( $data );
			my $update_d={name=>$a->{name}, givenname=>$a->{vorname}, birthdate=>$a->{geburtsdatum}, telephone=>$a->{tel}, town=>$a->{ort}, zip=>$a->{plz}, street=>$a->{anschrift} };
			my($stmt, @bind) = $sql->update($table, $update_d, {$pk=>$key});
			my $sth = $self->db->prepare($stmt);
			$sth->execute(@bind);
		}
	}
	$self->render( json=> $ret);
};

helper mapTableNameForWriting => sub { my ($self, $table)=@_;
	return 'trials' if $table eq 'all_trials';
	return 'personnel' if $table eq 'personnel_catalogue';
	return $table;
};

helper getObjectFromTable => sub { my ($self, $table, $id, $dbh_dc)=@_;
	my $dbh  = $dbh_dc? $dbh_dc: $self->db;
	return undef if $id eq 'null';
	my $sth = $dbh->prepare( qq/select * from "/.$table.qq/" where id=?/);
	$sth->execute(($id));
	return $sth->fetchrow_hashref();
};
		
# insert
post '/DBI/:table/:pk'=> sub
{	my $self	= shift;
	my $table	= $self->param('table');
	my $pk		= $self->param('pk');
	my $sql = SQL::Abstract->new;
	my $json_decoder= Mojo::JSON->new;
	my $jsonR   = $json_decoder->decode( $self->req->body );

	my($stmt, @bind) = $sql->insert( $self->mapTableNameForWriting($table), $jsonR || {name=>'New'});
	my $sth = $self->db->prepare($stmt);
	$sth->execute(@bind);
	app->log->debug("err: ".$DBI::errstr ) if $DBI::errstr;
	my $valpk= $self->db->last_insert_id(undef, undef, $table, $pk);
	$self->render( json=>{err=> $DBI::errstr, pk => $valpk} );
};

# delete
del '/DBI/:table/:pk/:key'=> [key=>qr/\d+/] => sub
{	my $self	= shift;
	my $table	= $self->param('table');
	my $pk		= $self->param('pk');
	my $key		= $self->param('key');
	my $sql = SQL::Abstract->new;

	my($stmt, @bind) = $sql->delete($table, {$pk=>$key});
	my $sth = $self->db->prepare($stmt);
	$sth->execute(@bind);
	app->log->debug("err: ".$DBI::errstr ) if $DBI::errstr;
	$self->render( json=>{err=> $DBI::errstr} );
};

helper get_XLS_for_arr => sub { my ($self, $ret, $hr)=@_;
	use Spreadsheet::WriteExcel;
	use TempFileNames;
		
	my $tmpfilename=tempFileName('/tmp/dbweb','xls');
	my $workbook = Spreadsheet::WriteExcel->new($tmpfilename);
	my $format = $workbook->add_format();
	$format->set_bold();
	my $worksheet = $workbook->add_worksheet();
	my @cols= @$hr;
	my ($i,$j);
	# titelzeile in bold
	foreach my $currCol (@cols)
	{	$currCol=~s/\=//ogs;
		$worksheet->write(0, $j, $currCol, $format);
		$j++;
	} $i=1;
	foreach my $currRow   ( @{$ret} )
	{	$j=0;
		foreach my $currCol (@$currRow)
		{	$currCol=~s/\=//ogs;
			$worksheet->write($i, $j, $currCol);
			$j++;
		} $i++;
	}
	$workbook->close();
	my $xls=readFile($tmpfilename);
	return $xls;
};
		
###############
# specific apis
get '/CT/download_list'=> sub
{	my $self=shift;
	my $excel = $self->param('excel');
	my $sessionid=$self->param('session');
	my $dbh=$self->db;
	my $sql=qq{SELECT distinct name FROM trial_properties_catalogue join trial_properties on trial_properties.idproperty=trial_properties_catalogue.id order by 1};
	my $sth = $dbh->prepare( $sql );
	my  %session;
	tie %session, 'Apache::Session::File', $sessionid , {Transaction => 0};
	$sth->execute();
	my $a=$sth->fetchall_arrayref();
	my @colnames=map {'"'.$_->[0].'"' } @$a;
	my $colnames= join " text,",@colnames;
	$sql="SELECT distinct all_trials.name, ct.* FROM crosstab( 'select idtrial, trial_properties_catalogue.name, value from trial_properties join trial_properties_catalogue on idproperty= trial_properties_catalogue.id order by 1,2', 'SELECT distinct trial_properties_catalogue.name FROM trial_properties_catalogue join trial_properties on idproperty= trial_properties_catalogue.id order by 1') AS ct(idtrial integer, $colnames text) join all_trials on idtrial=all_trials.id join  group_assignments ON group_assignments.idgroup = all_trials.idgroup JOIN personnel_catalogue ON group_assignments.idpersonnel = personnel_catalogue.id where personnel_catalogue.ldap=? order by 1";
	$sth = $dbh->prepare( $sql );
	$sth->execute(($session{username}));
	if(!$excel)
	{	my $result=	"name\tidtrial\t".join("\t", @colnames)."\n";
		while(my $curr=$sth->fetchrow_arrayref())
		{	$result.=join("\t", (@$curr));
			$result.="\n";
		}
		$self->render(text=>$result);
	} else
	{	my $outR=$sth->fetchall_arrayref();
		$self->render_file('data' => $self->get_XLS_for_arr($outR, $sth->{NAME}), 'format'   => 'xls', 'filename' => 'data.xls');
	}
};
get '/CT/download_patients/:idtrial' => [idtrial=>qr/[0-9]+/] => sub
{	my $self=shift;
	my $idtrial=$self->param('idtrial');
	my $sessionid=$self->param('session');
	my $dbh=$self->db;
	my $sql=qq{SELECT distinct code1, code2, piz, name, givenname, birthdate, state FROM patient_identification_log where idtrial=? and ldap=? order by 1};
	my  %session;
	tie %session, 'Apache::Session::File', $sessionid , {Transaction => 0};

	my $sth = $dbh->prepare( $sql );
	$sth->execute(($idtrial, $session{username}));
	{	my $outR=$sth->fetchall_arrayref();
		$self->render_file('data' => $self->get_XLS_for_arr($outR, $sth->{NAME}), 'format'   => 'xls', 'filename' => 'patients.xls');
	}
};

get '/CT/make_properties/:idtrial'=> sub {
	my $self=shift;
	my $idtrial=	$self->param("idtrial");
	my $sql="INSERT INTO trial_properties (idtrial, idproperty)  (select all_trials.id as idtrial, trial_properties_catalogue.id as idproperty from all_trials join trial_properties_catalogue on true left join trial_properties on idtrial=all_trials.id and trial_properties.idproperty=trial_properties_catalogue.id where trial_properties.id is null and type=1 and all_trials.id =$idtrial)";
	my $sth = $self->db->prepare($sql);
	$sth->execute();
	$self->render(text=>'OK');
};
		
helper performBooking => sub { my ($self, $piz, $dcid, $text)=@_;
	my $r= system("cd /Users/Shared/bin/BookAugDateCmd; java -jar /Users/Shared/bin/BookAugDateCmd/BookAugDateCmd.jar 10.210.21.10 augdb2 mko09ijn $piz $dcid");
	if(!$r)
	{	my $dbh_dc = DBI->connect("dbi:JDBC:hostname=localhost:9003;url=jdbc:sapdb://10.210.21.10:7210/augdb", 'daniel', 'bhu87zgv') || warn "Database connection not made: $DBI::errstr";
		my $sql='update "AUGDATE" set "ANNOTATION"=? where "AUGDATEID"=?';
		my $sth=$dbh_dc->prepare($sql);
		$sth->execute(($text, $dcid));	
		$dbh_dc->disconnect();
	}
	return $r;
};
		
post '/CT/booking/:piz/:dcid/:idvisit' => [piz=>qr/[0-9]+/o, dcid=>qr/[0-9]+/o, idvisit=>qr/[0-9]+/o] => sub {
	my $self=shift;
	my $piz=	$self->param("piz");
	my $dcid=	$self->param("dcid");
	my $text=   $self->req->body;
	my $visit=$self->getObjectFromTable('trial_visits', $self->param("idvisit"), );
	# refetch dcid-object to ensure it is still unbooked
	my $r='NOK';
	my $dc_obj=$self->getObjectFromTable('calendar', $dcid);
	if($dc_obj)
	{
		$r= $self->performBooking($piz, $dcid, $text);
		if($visit->{additional_docscal_booking_name})
		{	my $sql=qq|SELECT dcid, caldate FROM dblink('dbname=docscal_mirror hostaddr=10.210.21.37 user=postgres'::text, 'select * from bookable_docscal_dates(''|.$visit->{additional_docscal_booking_name}.qq|'')'::text) t1(source text, dcid integer, caldate timestamp without time zone) where caldate> ?  and caldate::date=?::date order by 2 limit 1|;
			my $sth=$self->db->prepare($sql);
			$sth->execute(($dc_obj->{startdate},$dc_obj->{startdate}));
			my $second=$sth->fetchrow_hashref();
			if($second)
			{	$r= $self->performBooking($piz, $second->{dcid}, $text);
			}
		}
	}
	$self->render(text=>$r);
};

helper LDAPChallenge => sub { my ($self, $name, $password)=@_;
	my $ldap = Net::LDAP->new( 'ldap://ldap.ukl.uni-freiburg.de' );
	my $msg = $ldap->bind( 'uid='.$name.', ou=people, dc=ukl, dc=uni-freiburg, dc=de', password => $password);
	return $msg->code==0;
};

get '/AUTH' => sub {
	my $self=shift;
	my $user= $self->param('u');
	my $pass= $self->param('p');
	my $sessionid='';
	if($user)
	{	if($self->LDAPChallenge($user,$pass))
		{	my  %session;
			tie %session, 'Apache::Session::File', undef , {Transaction => 0};
			$sessionid = $session{_session_id};
			$session{username}=$user;
		}
	} $self->render(text => $sessionid );
};

get '/CT/CAL/:year/:month'=> [year =>qr/\d+/, month =>qr/\d+/] => sub
{	my $self=shift;
	my $year		= $self->param('year');
	my $month		= $self->param('month');
	my $sql=qq/select * from calendar_function(?,?)/;
	my $sth =  $self->db->prepare( $sql );
	$sth->execute(($month, $year));
	my @a;
	while(my $c=$sth->fetchrow_hashref())
	{	push @a,$c;
	}
	$self-> render( json=>\@a );
};
get '/CT/CAL/:date'=> [date =>qr/[-\d]+/] => sub
{	my $self=shift;
	my $date		= $self->param('date');
	my $sessionid=$self->param('session');
	my  %session;
	tie %session, 'Apache::Session::File', $sessionid , {Transaction => 0};
	my $dbh=$self->db;
	my $sql="SELECT * from event_overview where event_date::date=? and ldap=?";
	my $sth = $dbh->prepare( $sql );
	$sth->execute(($date, $session{username}));
	my @a;
	while(my $c=$sth->fetchrow_hashref())
	{	push @a,$c;
	}
	$self-> render( json=> \@a );
};

helper getPropertiesDict => sub { my ($self, $idtrial, $ldap)=@_;
	my $dbh=$self->db;
	my $sql=qq{SELECT name, value FROM trial_properties join trial_properties_catalogue on idproperty=trial_properties_catalogue.id where idtrial=? union select 'today' as name, now()::date::text as value union all SELECT process_steps_catalogue.name||' (Start)' as name, trial_process_step.start_date::text AS value FROM trial_process_step JOIN process_steps_catalogue ON trial_process_step.type = process_steps_catalogue.id where idtrial=? union all  SELECT process_steps_catalogue.name||' (End)', trial_process_step.end_date::text AS value FROM trial_process_step JOIN process_steps_catalogue ON trial_process_step.type = process_steps_catalogue.id where idtrial=? order by 1};
	my $sth = $dbh->prepare( $sql );
	$sth->execute(($idtrial, $idtrial, $idtrial));
	my $a=$sth->fetchall_arrayref();
	my $keyvaldict={};
	$keyvaldict->{$_->[0]}=$_->[1] for @$a;
		
	# union person-specific data such as name, title, function from personnel-table via ldap
	$sth = $dbh->prepare( qq/select * from personnel_catalogue where ldap=?/);
	$sth->execute(($ldap));
	my $perso=$sth->fetchrow_hashref();
	$keyvaldict->{_Loginname_}=$perso->{name}; 
	$keyvaldict->{_Loginrole_}=$perso->{function};
	return $keyvaldict;
};
get '/CT/pdfstamper/:idtrial/:formname'=> [idtrial =>qr/\d+/, formname =>qr/[a-z\d_]+/i] => sub
{	my $self=shift;
	my $idtrial = $self->param('idtrial');
	my $formname= $self->param('formname');
	my $sessionid=$self->param('session');
	my  %session;
	tie %session, 'Apache::Session::File', $sessionid , {Transaction => 0};
	my $ldap=$session{username};
	my $keyvaldict=$self->getPropertiesDict($idtrial, $ldap);
	my $data= pdfgen::PDFForTemplateAndRef(TempFileNames::readFile(form_repo_path. $formname.'.tex'), $keyvaldict);
	$self->render(data=> $data , format =>'pdf' );
};

# <!> refactor rest of this file to use me
helper insertDictIntoTable => sub { my ($self, $table, $dict)=@_;
	my $sql = SQL::Abstract->new;
	my $dbh=$self->db;
		
	my($stmt, @bind) = $sql->insert($table,  $dict);
	my $sth = $dbh->prepare($stmt);
	$sth->execute(@bind);
	return $dbh->last_insert_id(undef, undef, $table, 'id');
};
get '/CT/new_patient/:idtrial' => [idtrial=>qr/[0-9]+/] => sub	# post
{	my $self	= shift;
	my $idtrial	= $self->param('idtrial');
	my $dbh=$self->db;
	my $idpatient= $self->insertDictIntoTable('patients',  {idtrial=> $idtrial} );
	my $stmt = 'select idreference_visit from trial_visits where idtrial=? and idreference_visit is not null limit 1';
	my $sth = $dbh->prepare($stmt);
	$sth->execute(($idtrial));
	my $outR=$sth->fetchall_arrayref();
	my $idreference_visit;
	$idreference_visit= $outR->[0]->[0] if $outR && scalar @$outR;
	my $currentDate=DateTime->now->ymd;
	$self->insertDictIntoTable('patient_visits', {idpatient=> $idpatient, visit_date=> $currentDate, idvisit=> $idreference_visit} ) if $idreference_visit;
	$stmt = "insert into  patient_visits (idpatient, idvisit) select $idpatient as idpatient, trial_visits.id as idvisit from trial_visits where idtrial=? and idreference_visit is not null and id not in (?) order by visit_interval";
	$sth = $dbh->prepare($stmt);
	$sth->execute(($idtrial, $idreference_visit));
	$self->render(text=>$idpatient);
};
		
###################################################################
# docscal interface

get '/CT/DC/:download/dir/:piz'=> [download =>qr/[a-z]+/, piz =>qr/\d{8}/] => sub
{	my $self=shift;
	my $piz= $self->param("piz");
	my $download= $self->param("download");
	my $ua = Mojo::UserAgent->new;
	my $data=$ua->get('http://augimageserver/'.$download.'/'.$piz.'?peek=1')->res->body;
	$self->render( text => $data);
};
get '/CT/DC/:download/dir/:piz/:type' => [download =>qr/[a-z]+/, piz =>qr/\d{8}/] => sub
{	my $self=shift;
	my $piz= $self->param("piz");
	my $download= $self->param("download");
	my $type= $self->param("type");
	my $ua = Mojo::UserAgent->new;
	my $data=$ua->get('http://augimageserver/'.$download.'/'.$piz.'?dir='.$type)->res->body;
	$self->render( text=> $data);
};
get '/CT/DC/:download/fetch/:name/:scale'=> [download =>qr/[a-z]+/, name =>qr/.+/] => sub
{	my $self=shift;
	my $name= $self->param("name");
	my $download= $self->param("download");
	my $scale= $self->param("scale");
	my $ua = Mojo::UserAgent->new;
	my $data=$ua->get("http://augimageserver/'.$download.'/$name?size=$scale")->res->body;
	$self->render(data=> $data , format =>'jpg' );
};

###################################################################
# to be factored out
#<!> fixme: this ugly stuff should be factored out in a driver module
get '/CT/print_bill/:idtrial'=> [idtrial =>qr/\d+/] => sub
{	my $self=shift;
	my $idtrial = $self->param('idtrial');
	my $sessionid=$self->param('session');
	my  %session;
	tie %session, 'Apache::Session::File', $sessionid , {Transaction => 0};
	my $ldap=$session{username};
		
	my $keyvaldict=$self->getPropertiesDict($idtrial, $ldap);
		
	use Spreadsheet::ParseExcel;
	use Spreadsheet::ParseExcel::SaveParser;

	my $parser   = new Spreadsheet::ParseExcel::SaveParser;
	my $template = $parser->Parse(form_repo_path. 'Rechnungserstellung.xls');

	# Get the worksheet
	my $worksheet = $template->worksheet(0);
	my $cell = $worksheet->get_cell( 33, 0 );
	my $formatfooter_number = $cell->{FormatNo};
	$cell = $worksheet->get_cell( 33, 6 );
	my $formatfooter_number2 = $cell->{FormatNo};

	$template->AddCell( 0, 6, 3, $keyvaldict->{_Loginname_} );
	$template->AddCell( 0, 7, 3, "Augenklinik" );
	$template->AddCell( 0, 8, 3, "Klinische Studien" );
	$template->AddCell( 0,12, 3, $keyvaldict->{Sponsor} );
	$template->AddCell( 0,14, 3, $keyvaldict->{Monitor} );
	$template->AddCell( 0,19, 3, $keyvaldict->{'USt-ID'} );
	$template->AddCell( 0,28, 3, $keyvaldict->{Drittmittelnummer} );
	$template->AddCell( 0,29, 3, $keyvaldict->{'Voller Titel'} );

	my $sql = SQL::Abstract::More->new;
	my($stmt, @bind) = $sql->select( -columns  => qw/*/, -from => 'list_for_billing', -where => {idtrial => $idtrial});
	my $sth = $self->db->prepare($stmt);
	$sth->execute(@bind);
	my $i=32;
	my $sum=0;
	my $idstr='';
	while(my $c=$sth->fetchrow_hashref())
	{	$c->{visit_date}=~s/00:00:00//ogs;
		$template->AddCell( 0,$i, 0, $c->{code1}.' '.$c->{code2}.' '.$c->{visit} );
		$template->AddCell( 0,$i, 1, '');
		$template->AddCell( 0,$i, 2, '');
		$template->AddCell( 0,$i, 3, $c->{visit_date});
		$template->AddCell( 0,$i, 4, '1');
		$template->AddCell( 0,$i, 5, $c->{reimbursement}.' EUR');
		$template->AddCell( 0,$i, 6, $c->{reimbursement}.' EUR');
		$i++;
		$sum+=$c->{reimbursement};
		$idstr.=$c->{id}.', ';
	}
	#	my $format = $worksheet->add_format();
	#	$format->set_bold();
	my $ust=$sum*0.19;
	$template->AddCell( 0,$i, 0, 'Summe', $formatfooter_number);
	$template->AddCell( 0,$i, $_, '', $formatfooter_number) for 1..5;
	$template->AddCell( 0,$i, 6, sprintf('%4.2f EUR',$sum), $formatfooter_number2);
	$template->AddCell( 0,$i+1, 0, 'Ust. 19 Prozent', $formatfooter_number);
	$template->AddCell( 0,$i+1, $_, '', $formatfooter_number) for 1..5;
	$template->AddCell( 0,$i+1, 6, sprintf('%4.2f EUR',$ust), $formatfooter_number2);
	$template->AddCell( 0,$i+2, 0, 'Rechnungsbetrag', $formatfooter_number);
	$template->AddCell( 0,$i+2, $_, '', $formatfooter_number) for 1..5;
	$template->AddCell( 0,$i+2, 6, sprintf('%4.2f EUR',$sum+$ust), $formatfooter_number2);
	
	my $tmpfilename=tempFileName('/tmp/dbweb','xls');
	$template->SaveAs($tmpfilename);
	my $xls=readFile ($tmpfilename);

	my $insert = SQL::Abstract->new;
	($stmt, @bind) = $insert->insert( 'billings', {idtrial=>$idtrial, comment=> sprintf('%4.2f EUR',$sum+$ust), visit_ids=>$idstr});
	$sth = $self->db->prepare($stmt);
	$sth->execute(@bind);

	$self->render_file('data' => $xls, 'format'   => 'xls', 'filename' => 'rechnung.xls');
};


###################################################################
# main()

app->config(hypnotoad => {listen => ['http://*:3004'], workers => 5, heartbeat_timeout=>1200, inactivity_timeout=> 1200});
app->start;
