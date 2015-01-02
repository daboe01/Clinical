#!/usr/local/ActivePerl-5.14/site/bin/morbo

# todo: sanitize filenames upon upload
#        support multiple files of samename (as in cellfinder)

use lib qw {/Users/daboe01/src/daboe01_Clinical/Clinical};
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
use Mojolicious::Plugin::RenderFile;
use pdfgen;
use DateTime;
use Mojo::UserAgent::Proxy;
use Date::ICal;
use Data::ICal;
use Data::ICal::Entry::Event;
use Data::ICal::Entry::TimeZone;
use Mojo::JSON qw(decode_json encode_json);

# enable receiving uploads up to 1GB
$ENV{MOJO_MAX_MESSAGE_SIZE} = 1_073_741_824;

plugin 'database', {
    dsn      => 'dbi:Pg:dbname=aug_clinical;host=localhost',
    username => 'root',
    password => 'root',
    options  => { 'pg_enable_utf8' => 1, AutoCommit => 1 },
    helper   => 'db'
};
plugin 'RenderFile';


use constant doku_repo_path => '/Users/daboe01/src/daboe01_Clinical/Clinical/docrepo/';
use constant form_repo_path => '/Users/daboe01/src/daboe01_Clinical/Clinical/forms/';
use constant proxy_string => 'http://U:P@193.196.237.21:80/';

#use constant doku_repo_path => '/Users/daboe01/src/daboe01_Clinicaltrials/Clinicaltrials/docrepo';

###########################################
# "fake" tables for DBI interface

helper getLSDocuments => sub { my ($self)=@_;
    my $_docrepo= doku_repo_path.'/';
    return    grep { defined $_->{idtrial} && $_->{tag} !~ /^\./ }
    map  { my ($p,$f)=split /\//o; ($f or '')=~/^([0-9]+)_(.+)/; 
            my $date = POSIX::strftime( "%Y-%m-%d", localtime( ( stat $_docrepo.$_ )[9] ) ); 
            {id=>"$1$2", idtrial=>$1, name=> $2, tag=>$p, date=> $date} }
    map  { s/^$_docrepo//ogs;$_}
    File::Find::Rule->in($_docrepo);
};
helper getLSPDocuments => sub { my ($self)=@_;
    my $_docrepo= doku_repo_path.'p/';
    return    grep { defined $_->{idpersonnel} && $_->{tag} !~ /^\./ }
    map  { my ($p,$f)=split /\//o; ($f or '')=~/^([0-9]+)_(.+)/; 
        my $date = POSIX::strftime( "%Y-%m-%d", localtime( ( stat $_docrepo.$_ )[9] ) ); 
        {id=>"$1$2", idpersonnel=>$1, name=> $2, tag=>$p, date=> $date} }
    map  { s/^$_docrepo//ogs;$_}
    File::Find::Rule->in($_docrepo);
};

get '/CT/download/:idtrial/:name' => [idtrial=>qr/[0-9]+/, name=>qr/.+/] => sub {
    my $self=shift;
    my $idtrial=    $self->param("idtrial");
    my $name= $self->param("name");
    my $id    ="$idtrial$name";
    my @doc=grep {$_->{id} eq $id} $self->getLSDocuments();
    my $format;
    $format=$1 if $name=~/\.([^\.]+)$/o;
    $self->render(data => TempFileNames::readFile(doku_repo_path.'/' . $doc[0]->{tag} .'/' . $idtrial.'_'. $name), format => $format );
};
get '/CT/pdownload/:idperso/:name' => [idperso=>qr/[0-9]+/, name=>qr/.+/] => sub {
    my $self=shift;
    my $idperso=    $self->param("idperso");
    my $name= $self->param("name");
    my $id    ="$idperso$name";
    my @doc=grep {$_->{id} eq $id} $self->getLSPDocuments();
    my $format;
    $format=$1 if $name=~/\.([^\.]+)$/o;
    $self->render(data => TempFileNames::readFile(doku_repo_path.'p/' . $doc[0]->{tag} .'/' . $idperso.'_'. $name), format => $format );
};

get '/DBI/documents'=> sub
{   my $self = shift;
    $self->render( json=> $self->getLSDocuments() );
};
get '/DBI/pdocuments'=> sub
{   my $self = shift;
    $self->render( json=> $self->getLSPDocuments() );
};
get '/DBI/doctags_catalogue'=> sub
{   my $self = shift;
    my %tags=();
    $tags{$_->{tag}}='' for $self->getLSDocuments();
    my @ret=  map {{name=>$_}} grep {length $_} (keys %tags);
    $self->render( json=> \@ret);
};
get '/DBI/pdoctags_catalogue'=> sub
{   my $self = shift;
    my %tags=();
    $tags{$_->{tag}}='' for $self->getLSPDocuments();
    my @ret=  map {{name=>$_}} grep {length $_} (keys %tags);
    $self->render( json=> \@ret);
};
get '/DBI/documents/idtrial/:pk' => [pk=>qr/[a-z0-9\s_]+/i] => sub
{   my $self = shift;
    my $pk  = $self->param('pk');
    my @dir= grep {$_->{idtrial} eq $pk} $self->getLSDocuments();
    $self->render( json=> \@dir );
};
get '/DBI/pdocuments/idpersonnel/:pk' => [pk=>qr/[a-z0-9\s_]+/i] => sub
{   my $self = shift;
    my $pk  = $self->param('pk');
    my @dir= grep {$_->{idpersonnel} eq $pk} $self->getLSPDocuments();
    $self->render( json=> \@dir );
};

# unused?!
get '/DBI/documents/id/:pk' => [pk=>qr/[a-z0-9\s_ ]+/i] => sub
{   my $self = shift;
    my $pk  = $self->param('pk');
    my @dir= grep {$_->{id} eq $pk} $self->getLSDocuments();
    $self->render( json=> \@dir );
};
# unused?!
get '/DBI/pdocuments/id/:pk' => [pk=>qr/[a-z0-9\s_ ]+/i] => sub
{   my $self = shift;
    my $pk  = $self->param('pk');
    my @dir= grep {$_->{id} eq $pk} $self->getLSPDocuments();
    $self->render( json=> \@dir );
};
get '/DBI/documents_tag_unique/idtrial/:pk' => [pk=>qr/[a-z0-9\s]+/i] => sub
{   my $self = shift;
    my $pk  = $self->param('pk');
    my @dir= grep {$_->{idtrial} eq $pk} $self->getLSDocuments();
    my %seen;
    $seen{$_->{tag}}='' for @dir;
    my @dir2 = map { {id=>"$pk$_", idtrial=>$pk, tag=>$_} } keys %seen;
    $self->render( json=> \@dir2 );
};
get '/DBI/pdocuments_tag_unique/idpersonnel/:pk' => [pk=>qr/[a-z0-9\s]+/i] => sub
{   my $self = shift;
    my $pk  = $self->param('pk');
    my @dir= grep {$_->{idpersonnel} eq $pk} $self->getLSPDocuments();
    my %seen;
    $seen{$_->{tag}}='' for @dir;
    my @dir2 = map { {id=>"$pk$_", idpersonnel=>$pk, tag=>$_} } keys %seen;
    $self->render( json=> \@dir2 );
};

# update docs
put '/DBI/documents/id/:key'=> [key=>qr/.+/] => sub
{   my $self    = shift;
    my $jsonR   = decode_json( $self->req->body );
    my $key        = $self->param('key');
    my @doc=grep {$_->{id} eq $key} $self->getLSDocuments();
    my $idtrial=$doc[0]->{idtrial};
    my $name=    $doc[0]->{name};
    my $oldname=doku_repo_path.'/' . $doc[0]->{tag} .'/' . $idtrial.'_'. $name;
    my $newname=$jsonR->{tag}?  doku_repo_path.'/'  . $jsonR->{tag} .'/'  . $idtrial.'_'. $name:
                                doku_repo_path.'/'  . $doc[0]->{tag} .'/' . $idtrial.'_'. $jsonR->{name};
    rename $oldname, $newname;
    $self->render( json=> {err=> ''} );
};
put '/DBI/pdocuments/id/:key'=> [key=>qr/.+/] => sub
{   my $self = shift;
    my $jsonR = decode_json( $self->req->body );
    my $key = $self->param('key');
    my @doc=grep {$_->{id} eq $key} $self->getLSPDocuments();
    my $idpersonnel=$doc[0]->{idpersonnel};
    my $name= $doc[0]->{name};
    my $oldname=doku_repo_path.'p/' . $doc[0]->{tag} .'/' . $idpersonnel.'_'. $name;
    my $newname=$jsonR->{tag}?  doku_repo_path.'p/'  . $jsonR->{tag} .'/'  . $idpersonnel.'_'. $name:
    doku_repo_path.'p/'  . $doc[0]->{tag} .'/' . $idpersonnel.'_'. $jsonR->{name};
    rename $oldname, $newname;
    $self->render( json=> {err=> ''} );
};
# delete doc
del '/DBI/documents/id/:key'=> [key=>qr/.+/] => sub
{   my $self    = shift;
    my $key        = $self->param('key');

    my @doc=grep {$_->{id} eq $key} $self->getLSDocuments();
    my $idtrial=$doc[0]->{idtrial};
    my $name=    $doc[0]->{name};
    my $oldname=doku_repo_path.'/'  . $doc[0]->{tag} .'/' . $idtrial.'_'. $name;
    unlink $oldname;
    $self->render( json=> {err=> ''} );
};
del '/DBI/pdocuments/id/:key'=> [key=>qr/.+/] => sub
{   my $self    = shift;
    my $key        = $self->param('key');
    
    my @doc=grep {$_->{id} eq $key} $self->getLSPDocuments();
    my $idpersonnel=$doc[0]->{idpersonnel};
    my $name=    $doc[0]->{name};
    my $oldname=doku_repo_path.'p/'  . $doc[0]->{tag} .'/' . $idpersonnel.'_'. $name;
    unlink $oldname;
    $self->render( json=> {err=> ''} );
};

# POST /upload (push one or more files to app)
post '/upload/:idtrial' => [idtrial=>qr/[0-9]+/] => sub {
    my $self    = shift;
    my $idtrial=    $self->param("idtrial");
    my $suffix=    $self->param("suffix");
    my @uploads = $self->req->upload('files[]');
    for my $curr_upload (@uploads) {
        my $upload  = Mojo::Upload->new($curr_upload);
        my $bytes = $upload->slurp;
        my $filename=$upload->filename;
        $filename=~s/[^0-9a-z\-\. ']/_/ogsi;
        TempFileNames::writeFile(doku_repo_path.$suffix.'/' .'Unclassified/'.$idtrial.'_'.$filename, $bytes);
    }
    $self->render( json => \@uploads );
};

# POST /upload (push one or more files to app)
post '/pupload/:idpersonnel' => [idpersonnel=>qr/[0-9]+/] => sub {
    my $self    = shift;
    my $idpersonnel=    $self->param("idpersonnel");
    my $suffix= 'p';
    my @uploads = $self->req->upload('files[]');
    for my $curr_upload (@uploads) {
    my $upload  = Mojo::Upload->new($curr_upload);
    my $bytes = $upload->slurp;
    my $filename=$upload->filename;
    $filename=~s/[^0-9a-z\-\. ']/_/ogsi;
    TempFileNames::writeFile(doku_repo_path.$suffix.'/' .'Unclassified/'.$idpersonnel.'_'.$filename, $bytes);
    }
    $self->render( json => \@uploads );
};


###########################################
# generic dbi part
helper getUserlevel => sub { my ($self, $ldap)=@_;
    my $o=$self->getObjectFromTable('personnel_catalogue', $ldap, undef, 'ldap');
    return $o->{level};
};

helper fetchFromTable => sub { my ($self, $table, $sessionid, $where)=@_;
    my $sql = SQL::Abstract::More->new;

    my $order_by=[];
    my @a;
    if($sessionid)        # implement session-bound serverside security
    {   my  %session;
        tie %session, 'Apache::Session::File', $sessionid , {Transaction => 0};
        my @cols=qw/*/;
        if($table eq 'all_trials')
        {   $table = 'trials';
            @cols=qw/id idgroup name codename infotext global_state fulltext sponsor phase indikation/;
            $where->{ldap}= $session{username};
        } elsif($table eq 'trial_property_annotations')
        {   $where->{ldap}= $session{username};
        } elsif($table eq 'patient_visits')
        {   $table = 'patient_visits_rich';
            @cols=qw/id idpatient idvisit visit_date state lower_margin center_margin upper_margin missing_service ordering comment travel_costs date_reimbursed travel_comment travel_additional_costs/;
        } elsif($table eq 'accounts_balanced')
        {   $table = 'accounts_balanced_ldap';
            @cols=qw/idaccount date_transaction type description amount_change balance/;
            $where->{ldap}= $session{username};
        } elsif($table eq 'shadow_accounts')
        {   $table = 'shadow_accounts_ldap';
            @cols=qw/id account_number idgroup name balance/;
            $where->{ldap}= $session{username};
        } elsif($table eq 'trial_properties_distinct')
        {   $table = 'trial_properties';
            @cols=qw/idproperty value/;
            $order_by=[qw/+value/];
        } elsif($table eq 'personnel_costs')
        {   my $level=$self->getUserlevel($session{username});
            $where->{1}=0 if $level < 3;
        } elsif($table eq 'visit_procedures')
        {   $table = 'visit_procedures_name';
            @cols=qw/id idvisit idprocedure actual_cost procedure_name ordering parameter/;
        } elsif($table eq 'visit_procedure_values')
        {   $table = 'visit_procedure_values_ordered';
        }        
        $where->{$_}= $where->{$_} eq 'NULL'? undef : $where->{$_} for keys %$where;
        #    support table-specific autosorting via hash
        my $autosorting={
                trial_visits=>                          [qw/+visit_interval/],
                patient_visits_rich=>                   [qw/+ordering/],
                visit_procedure_values_ordered =>       [qw/+ordering/]
        };
        $order_by= $autosorting->{$table} if exists $autosorting->{$table};
        my($stmt, @bind) = $sql->select( -columns  => [-distinct => @cols], -from => $table, -where=> $where, -order_by=> $order_by);
        my $sth = $self->db->prepare($stmt);
        $sth->execute(@bind);
        
        while(my $c=$sth->fetchrow_hashref())
        {   push @a,$c;
        }
    }
    return \@a;
};

# fetch all entities
get '/DBI/:table'=> sub
{   my $self = shift;
    my $table  = $self->param('table');
    my $sessionid  = $self->param('session');
    my $res=$self->fetchFromTable($table, $sessionid, {});
    $self-> render( json => $res);
};

# fetch entities by (foreign) key
get '/DBI/:table/:col/:pk' => [col=>qr/[a-z_0-9\s]+/, pk=>qr/[a-z0-9\s\-]+/i] => sub
{   my $self = shift;
    my $table  = $self->param('table');
    my $pk  = $self->param('pk');
    my $col  = $self->param('col');
    my $sessionid  = $self->param('session');
    my $res=$self->fetchFromTable($table, $sessionid, {$col=> $pk});
    $self-> render( json => $res);
};

helper getTypeHashForTable => sub { my ($self, $table)=@_;
    my $sth = $self->db->column_info('','',$table,'');
    my $info = $sth->fetchall_arrayref({});
    my $ret={};
    foreach (@$info)
    {   $ret->{$_->{COLUMN_NAME}}=$_->{TYPE_NAME};
    }
    return $ret;
};
        
# update
put '/DBI/:table/:pk/:key'=> [key=>qr/\d+/] => sub
{   my $self    = shift;
    my $table   = $self->param('table');
    my $pk      = $self->param('pk');
    my $key     = $self->param('key');
    my $sql     = SQL::Abstract->new;
    my $jsonR   = decode_json( $self->req->body );

   my  %session;
   my $sessionid=$self->param('session');
   tie %session, 'Apache::Session::File', $sessionid , {Transaction => 0};
   my $ldap = $session{username};

    my $types = $self->getTypeHashForTable($table);
    for (keys %$jsonR)    ## support for nullifying dates and integers with empty string or special string NULL
    {
        $jsonR->{$_}= ($jsonR->{$_} =~/(^NULL$)|(^\s*$)/o && $types->{$_} !~/text|varchar/o )? undef : $jsonR->{$_} ;
    }
    if($table eq 'personnel_catalogue')
    {
        my $level=$self->getUserlevel($ldap);
        if(exists $jsonR->{level} && $jsonR->{level} > $level)
        {
            $self->render( json=> {err=>'Privilege violation'});
            return;
        }
    }
    if($table eq 'group_assignments')
    {   my $level=$self->getUserlevel($ldap);
        if($level < 3)
        {   if(exists $jsonR->{idgroup})
            {
                my $u=$self->getObjectFromTable('personnel_catalogue', $ldap, undef, 'ldap');
                my $o=$self->getObjectFromTable('group_assignments', $u->{id}, undef, 'idpersonnel');
                unless ($self->hasRow('group_assignments', {idpersonnel=> $u->{id}, idgroup=> $jsonR->{idgroup} } ))
                {
                    $self->render( json=> {err=>'Privilege violation'});
                    return;
                }
            }
        }
    }
    $table = 'visit_procedures_name' if $table eq 'visit_procedures' && exists $jsonR->{procedure_name};
    my($stmt, @bind) = $sql->update($table, $jsonR, {$pk=>$key});
    my $sth = $self->db->prepare($stmt);
    $sth->execute(@bind);
    app->log->debug("err: ".$DBI::errstr ) if $DBI::errstr;
    my $ret={err=> $DBI::errstr};

    if($table eq 'patients')    # autofetch stammdaten if a piz is spezified
    {
        if($jsonR->{piz})
        {
            my $ua = Mojo::UserAgent->new;
            my $data='{}'; # $ua->get('http://auginfo/piz/'.$jsonR->{piz})->res->body;
            my $a= decode_json( $data );
            my $update_d={name=>$a->{name}, givenname=>$a->{vorname}, birthdate=>$a->{geburtsdatum}, telephone=>$a->{tel}, town=>$a->{ort}, zip=>$a->{plz}, street=>$a->{anschrift}, female=>$a->{weiblich}||'0' };
            my($stmt, @bind) = $sql->update($table, $update_d, {$pk=>$key});
            my $sth = $self->db->prepare($stmt);
            $sth->execute(@bind);
        }
    }
   ($stmt, @bind) = $sql->insert('audittrail', { action => 1, writetable => $table, username => $ldap, newdata=> $self->req->body, whereclause=> encode_json({$pk=>$key}) });
    $sth = $self->db->prepare($stmt);
    $sth->execute(@bind);
    $self->render( json=> $ret);
};

helper mapTableNameForWriting => sub { my ($self, $table)=@_;
    return 'trials' if $table eq 'all_trials';
    return 'personnel' if $table eq 'personnel_catalogue';
    return $table;
};

helper getObjectFromTable => sub { my ($self, $table, $id, $dbh_dc, $pk)=@_;
    my $dbh  = $dbh_dc? $dbh_dc: $self->db;
    return undef if $id eq 'null' ||  $id eq 'NULL' ||  $id eq '';
    $pk='id' unless $pk;
    my $sth = $dbh->prepare( qq/select * from "/.$table.qq/" where "/.$pk.qq/"=?/);
    $sth->execute(($id));
    return $sth->fetchrow_hashref();
};
        
# insert
post '/DBI/:table/:pk'=> sub
{   my $self    = shift;
    my $table    = $self->param('table');
    my $pk        = $self->param('pk');
    my $sql = SQL::Abstract->new;
    my $jsonR   = decode_json( $self->req->body );

    my  %session;
    my $sessionid=$self->param('session');
    tie %session, 'Apache::Session::File', $sessionid , {Transaction => 0};
    my $ldap = $session{username};

    if($table eq 'personnel_catalogue')
    {        my $level=$self->getUserlevel($ldap);
        $jsonR->{level}= $level if exists $jsonR->{level} && $jsonR->{level} > $level;
        $jsonR->{name}= 'New' unless exists $jsonR->{name};
    }        
    my($stmt, @bind) = $sql->insert( $self->mapTableNameForWriting($table), $jsonR || {name=>'New'});
    my $sth = $self->db->prepare($stmt);
    $sth->execute(@bind);
    app->log->debug("err: ".$DBI::errstr ) if $DBI::errstr;
    my $valpk;
    $valpk = (exists $jsonR->{$pk})? $jsonR->{$pk}:$self->db->last_insert_id(undef, undef, $table, $pk);

   ($stmt, @bind) = $sql->insert('audittrail', { action => 2, writetable => $table, username => $ldap, newdata=> $self->req->body });
    $sth = $self->db->prepare($stmt);
    $sth->execute(@bind);

    $self->render( json=>{err=> $DBI::errstr, pk => $valpk} );
};

# delete
del '/DBI/:table/:pk/:key'=> [key=>qr/\d+/] => sub
{   my $self    = shift;
    my $table    = $self->param('table');
    my $pk        = $self->param('pk');
    my $key        = $self->param('key');
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
    {   $currCol=~s/\=//ogs;
        $worksheet->write(0, $j, $currCol, $format);
        $j++;
    } $i=1;
    foreach my $currRow   ( @{$ret} )
    {   $j=0;
        foreach my $currCol (@$currRow)
        {   $currCol=~s/\=//ogs;
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
{   my $self=shift;
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
    $sql="SELECT distinct all_trials.name, groups_catalogue.name as group, ct.* FROM crosstab( 'select idtrial, trial_properties_catalogue.name, value from trial_properties join trial_properties_catalogue on idproperty= trial_properties_catalogue.id order by 1,2', 'SELECT distinct trial_properties_catalogue.name FROM trial_properties_catalogue join trial_properties on idproperty= trial_properties_catalogue.id order by 1') AS ct(idtrial integer, $colnames text) join all_trials on idtrial=all_trials.id join  group_assignments ON group_assignments.idgroup = all_trials.idgroup JOIN personnel_catalogue ON group_assignments.idpersonnel = personnel_catalogue.id join groups_catalogue on groups_catalogue.id=all_trials.idgroup where personnel_catalogue.ldap=? order by 1";
    $sth = $dbh->prepare( $sql );
    $sth->execute(($session{username}));
    if(!$excel)
    {   my $result=    "name\tidtrial\tgroup\t".join("\t", @colnames)."\n";
        while(my $curr=$sth->fetchrow_arrayref())
        {   $result.=join("\t", (@$curr));
            $result.="\n";
        }
        $self->render(text=>$result);
    } else
    {   my $outR=$sth->fetchall_arrayref();
        $self->render_file('data' => $self->get_XLS_for_arr($outR, $sth->{NAME}), 'format'   => 'xls', 'filename' => 'data.xls');
    }
};
get '/CT/download_patients/:idtrial' => [idtrial=>qr/[0-9]+/] => sub
{   my $self=shift;
    my $idtrial=$self->param('idtrial');
    my $sessionid=$self->param('session');
    my $dbh=$self->db;
    my $sql=qq{SELECT distinct code1, code2, piz, name, givenname, birthdate, state, comment, insertion_date FROM patient_identification_log where idtrial=? and ldap=? order by 1};
    my  %session;
    tie %session, 'Apache::Session::File', $sessionid , {Transaction => 0};

    my $sth = $dbh->prepare( $sql );
    $sth->execute(($idtrial, $session{username}));
    my $outR=$sth->fetchall_arrayref();
    $self->render_file('data' => $self->get_XLS_for_arr($outR, $sth->{NAME}), 'format'   => 'xls', 'filename' => 'patients.xls');
};
        
get '/CT/todolist_trial/:idtrial' => [idtrial=>qr/[0-9]+/] => sub
{   my $self=shift;
    my $idtrial=$self->param('idtrial');
    my $sessionid=$self->param('session');
    my $dbh=$self->db;
    my $sql=qq{SELECT process_steps_catalogue.name AS procedure, personnel_catalogue.name, title as comment FROM trial_process_step JOIN process_steps_catalogue ON trial_process_step.type = process_steps_catalogue.id left join personnel_catalogue on personnel_catalogue.id=idpersonnel where idtrial=? and end_date is  null order by 1,3,2};
    my $sth = $dbh->prepare( $sql );
    $sth->execute(($idtrial));
    my $outR=$sth->fetchall_arrayref();
    $self->render_file('data' => $self->get_XLS_for_arr($outR, $sth->{NAME}), 'format'   => 'xls', 'filename' => 'todolist_trial.xls');
};
get '/CT/unbilledlist' =>  sub
{   my $self=shift;
    my $idtrial=$self->param('idtrial');
    my $sessionid=$self->param('session');
    my  %session;
    tie %session, 'Apache::Session::File', $sessionid , {Transaction => 0};
    my $dbh=$self->db;
    my $sql=qq{SELECT name, first_visit, last_visit, number_visits, amount from unbilled_visits where ldap=?};
    my $sth = $dbh->prepare( $sql );
    $sth->execute(($session{username}));
    my $outR=$sth->fetchall_arrayref();
    $self->render_file('data' => $self->get_XLS_for_arr($outR, $sth->{NAME}), 'format'   => 'xls', 'filename' => 'unbilled_visits.xls');
};
get '/CT/conflictlist' =>  sub
{   my $self=shift;
    my $idtrial=$self->param('idtrial');
    my $sessionid=$self->param('session');
    my  %session;
    tie %session, 'Apache::Session::File', $sessionid , {Transaction => 0};
    my $dbh=$self->db;
    my $sql=qq{SELECT visit_date, ldap, name as visit, piz from visit_conflicts_overview where ldap_filtering=?};
    my $sth = $dbh->prepare( $sql );
    $sth->execute(($session{username}));
    my $outR=$sth->fetchall_arrayref();
    $self->render_file('data' => $self->get_XLS_for_arr($outR, $sth->{NAME}), 'format'   => 'xls', 'filename' => 'absent_conflicts.xls');
};

get '/CT/duelist' => sub
{   my $self=shift;
    my $idtrial=$self->param('idtrial');
    my $sessionid=$self->param('session');
    my  %session;
    tie %session, 'Apache::Session::File', $sessionid , {Transaction => 0};
    my $dbh=$self->db;
    my $sql=qq{SELECT distinct trial, creation_date, due_date, comment, amount from due_billings_list where ldap=? order by 1,2,5};
    my $sth = $dbh->prepare( $sql );
    $sth->execute(($session{username}));
    my $outR=$sth->fetchall_arrayref();
    $self->render_file('data' => $self->get_XLS_for_arr($outR, $sth->{NAME}), 'format'   => 'xls', 'filename' => 'inkassoliste.xls');
};
get '/CT/todolist' => sub
{   my $self=shift;
    my $sessionid=$self->param('session');
    my  %session;
    tie %session, 'Apache::Session::File', $sessionid , {Transaction => 0};
    my $dbh=$self->db;
    my $sql=qq{SELECT  distinct all_trials.name, process_steps_catalogue.name AS procedure, personnel_catalogue.name, title as comment   FROM trial_process_step JOIN process_steps_catalogue ON trial_process_step.type = process_steps_catalogue.id left join personnel_catalogue on personnel_catalogue.id=idpersonnel join all_trials on all_trials.id=idtrial join group_assignments  on group_assignments.idgroup=all_trials.idgroup join personnel_catalogue pc1 on pc1.id=group_assignments.idpersonnel where pc1.ldap=? and end_date is  null order by 1,2,4};
    my $sth = $dbh->prepare( $sql );
    $sth->execute(($session{username}));
    my $outR=$sth->fetchall_arrayref();
    $self->render_file('data' => $self->get_XLS_for_arr($outR, $sth->{NAME}), 'format'   => 'xls', 'filename' => 'todolist_group.xls');
};        
get '/CT/make_properties/:idtrial'=> sub {
    my $self=shift;
    my $idtrial=    $self->param("idtrial");
    my $sql="INSERT INTO trial_properties (idtrial, idproperty)  (select all_trials.id as idtrial, trial_properties_catalogue.id as idproperty from all_trials join trial_properties_catalogue on true left join trial_properties on idtrial=all_trials.id and trial_properties.idproperty=trial_properties_catalogue.id where trial_properties.id is null and type=1 and all_trials.id =$idtrial)";
    my $sth = $self->db->prepare($sql);
    $sth->execute();
    $self->render(text=>'OK');
};
get '/CT/download_koka/:idtrial' => [idtrial=>qr/[0-9]+/] => sub {
    my $self=shift;
    my $idtrial=$self->param('idtrial');
    my $sessionid=$self->param('session');
    my $dbh=$self->db;
        my $sql=qq{select *, cost * 1.25 as cost_overhead from (SELECT idtrial, trial_visits.name as visit, procedures_catalogue.name as procedure, coalesce( actual_cost, base_cost) as cost FROM visit_procedures join procedures_catalogue on procedures_catalogue.id=idprocedure join trial_visits on trial_visits.id=idvisit order by idtrial, visit_interval) a where idtrial=?};
    my $sth = $dbh->prepare( $sql );
    $sth->execute(($idtrial));
    my $outR=$sth->fetchall_arrayref();
    $self->render_file('data' => $self->get_XLS_for_arr($outR, $sth->{NAME}), 'format'   => 'xls', 'filename' => 'koka_trial.xls');
};
get '/CT/copyover_koka_visit/:idvisitold/:idvisitnew' => [idvisitold =>qr/[0-9]+/, idvisitnew =>qr/[0-9]+/] => sub
{   my $self = shift;
    my $idvisitold = $self->param('idvisitold');
    my $idvisitnew = $self->param('idvisitnew');
    my $dbh=$self->db;
    my $stmt = 'insert into  visit_procedures (idprocedure, idvisit, actual_cost) select idprocedure, ? as idivsit, actual_cost from visit_procedures where idvisit=?';
    my $sth = $dbh->prepare($stmt);
    $sth->execute(($idvisitnew, $idvisitold));
    $self->render(text=>'OK');
};
        
helper performBooking => sub { my ($self, $piz, $dcid, $text)=@_;
    my $r= system("cd /Users/Shared/bin/BookAugDateCmd; /Library/Internet\\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/bin/java -jar /Users/Shared/bin/BookAugDateCmd/BookAugDateCmd.jar 10.210.21.10 UUU PPP $piz $dcid");
    if(!$r)
    {   my $dbh_dc = DBI->connect("XXX", 'UUU', 'PPP') || warn "Database connection not made: $DBI::errstr";
        my $sql='update "AUGDATE" set "ANNOTATION"=? where "AUGDATEID"=?';
        my $sth=$dbh_dc->prepare($sql);
        $sth->execute(($text, $dcid));    
        $dbh_dc->disconnect();
    }
    return $r;
};
        
post '/CT/booking/:piz/:dcid/:idvisit' => [piz=>qr/[0-9]+/o, dcid=>qr/[0-9]+/o, idvisit=>qr/[0-9]+/o] => sub {
    my $self=shift;
    my $piz=    $self->param("piz");
    my $dcid=    $self->param("dcid");
    my $text=   $self->req->body;
    my $visit=$self->getObjectFromTable('trial_visits', $self->param("idvisit"), );
    # refetch dcid-object to ensure it is still unbooked
    my $r='NOK';
    my $dc_obj=$self->getObjectFromTable('calendar', $dcid);
    if($dc_obj)
    {
        $r= $self->performBooking($piz, $dcid, $text);
        if($visit->{additional_docscal_booking_name})
        {   my $sql=qq|SELECT dcid, caldate FROM dblink('dbname=docscal_mirror hostaddr=XX user=postgres'::text, 'select * from bookable_docscal_dates(''|.$visit->{additional_docscal_booking_name}.qq|'')'::text) t1(source text, dcid integer, caldate timestamp without time zone) where caldate> ?  and caldate::date=?::date order by 2 limit 1|;
            my $sth=$self->db->prepare($sql);
            $sth->execute(($dc_obj->{startdate},$dc_obj->{startdate}));
            my $second=$sth->fetchrow_hashref();
            if($second)
            {   $r= $self->performBooking($piz, $second->{dcid}, $text);
            }
        }
    }
    $self->render(text=>$r);
};

helper LDAPChallenge => sub { my ($self, $name, $password)=@_;
return 1;
    my $ldap = Net::LDAP->new( 'ldap://ldap.ukl.uni-xxxx.de' );
    my $msg = $ldap->bind( 'uid='.$name.', ou=people, dc=ukl, dc=xxx, dc=de', password => $password);
    return $msg->code==0;
};

get '/AUTH' => sub {
    my $self=shift;
    my $user= $self->param('u');
    my $pass= $self->param('p');
    my $sessionid='';
    if($user)
    {   if($self->LDAPChallenge($user,$pass))
        {   my  %session;
            tie %session, 'Apache::Session::File', undef , {Transaction => 0};
            $sessionid = $session{_session_id};
            $session{username}=$user;
        }
    } $self->render(text => $sessionid );
};

get '/CT/CAL/:year/:month'=> [year =>qr/\d+/, month =>qr/\d+/] => sub
{   my $self=shift;
    my $year        = $self->param('year');
    my $month        = $self->param('month');
    my $sql=qq/select * from calendar_function(?,?)/;
    my $sth =  $self->db->prepare( $sql );
    $sth->execute(($month, $year));
    my @a;
    while(my $c=$sth->fetchrow_hashref())
    {   push @a,$c;
    }
    $self-> render( json=>\@a );
};
get '/CT/CAL/:date'=> [date =>qr/[-\d]+/] => sub
{   my $self=shift;
    my $date        = $self->param('date');
    my $sessionid=$self->param('session');
    my $personal=$self->param('personal');
    my  %session;
    tie %session, 'Apache::Session::File', $sessionid , {Transaction => 0};
    my $dbh=$self->db;
    my $sql="SELECT distinct name, event_date, type,piz,tooltip from event_overview where event_date::date=? and ".($personal?"ldap":"ldap_unfiltered")."=? order by 2";
    my $sth = $dbh->prepare( $sql );
    $sth->execute(($date, $session{username}));
    my @a;
    while(my $c=$sth->fetchrow_hashref())
    {   push @a,$c;
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

    my $trial= $self->getObjectFromTable('all_trials', $idtrial);
    $keyvaldict->{TITLE}=$trial->{name};

    return $keyvaldict;
};
any '/CT/pdfstamper/:idtrial/:formname'=> [idtrial =>qr/\d+/, formname =>qr/[a-z\d_]+/i] => sub
{   my $self=shift;
    my $idtrial = $self->param('idtrial');
    my $formname= $self->param('formname');
    my $piz= $self->param('piz');
    my $sessionid=$self->param('session');
    my $filter=$self->param('filter');
    my $kilometerpauschale=$self->getProperty($idtrial,'kilometerpauschale');

    my  %session;
    tie %session, 'Apache::Session::File', $sessionid , {Transaction => 0};
    my $ldap=$session{username};
    my $keyvaldict=$self->getPropertiesDict($idtrial, $ldap);
 #<!> fixme: protect piz with session!
    if($piz)
    {
        my $sql = SQL::Abstract::More->new;
        my $ua = Mojo::UserAgent->new;
        my $data='[]';    # $ua->get('http://auginfo/piz/'.$piz.'?history=4')->res->body;
        my $jsonR   = decode_json( $data );
        for my $curr_address (@$jsonR) {
            my @name_arr=split/\^/o,$curr_address->{name};
            $keyvaldict->{$curr_address->{type}.'_name'}="$name_arr[5] $name_arr[1] $name_arr[0]";
            my @addr_arr=split/\^/o,$curr_address->{address};
            $keyvaldict->{$curr_address->{type}.'_anrede'}=$curr_address->{geschlecht};
            $keyvaldict->{$curr_address->{type}.'_anrede2'}=$keyvaldict->{$curr_address->{type}.'_anrede'};
            $keyvaldict->{$curr_address->{type}.'_anrede3'}=$keyvaldict->{$curr_address->{type}.'_anrede'};
            $keyvaldict->{$curr_address->{type}.'_anrede2'}=~s/^Herr$/Herrn/ogs;
            $keyvaldict->{$curr_address->{type}.'_anrede3'}=~s/^Herr.*/r Herr Kollege/ogs;
            $keyvaldict->{$curr_address->{type}.'_anrede3'}=~s/^Frau.*/ Frau Kollegin/ogs;
            $keyvaldict->{$curr_address->{type}.'_street'}="$addr_arr[0]";
            $keyvaldict->{$curr_address->{type}.'_ort'}="$addr_arr[4] $addr_arr[2]";
        }
        $data='{}';   # $ua->get('http://auginfo/piz/'.$piz)->res->body;
        $jsonR   = decode_json( $data );
        for my $ckey (keys %$jsonR) {
            $keyvaldict->{"PAT_".$ckey}=$jsonR->{$ckey};
        }
        # get patient id
        my($stmt, @bind) = $sql->select( -columns  => [qw/id/], -from => 'patients', -where => {idtrial => $idtrial, piz=>$piz});
        my $sth = $self->db->prepare($stmt);
        $sth->execute(@bind);
        my $a=$sth->fetchall_arrayref();
        my $idpatient=$a && $a->[0]? $a->[0]->[0]: undef;
        if($idpatient)
        {
            my $pat= $self->getObjectFromTable('patients', $idpatient);
            for my $ckey (keys %$pat) {
                $keyvaldict->{$ckey}=$pat->{$ckey};
            }
            $keyvaldict->{iban}=~s/ //ogs;
            # get the visits
            my $sql=qq{select trial_visits.name as visit, patient_visits_rich.* from patient_visits_rich join trial_visits on trial_visits.id=idvisit where idpatient=?};
            $filter=~s/[^0-9,]//ogs;  # untaint
            $filter=~s/,$//ogs;
            $sql.=" and patient_visits_rich.id in( $filter )" if $filter;
            $sql.=" order by trial_visits.ordering, patient_visits_rich.visit_date";
            my $sth = $self->db->prepare( $sql );
            $sth->execute(($idpatient));
            my @visits;
            my $sum=0;
            while(my $c=$sth->fetchrow_hashref())
            {
                my $reisekosten=$c->{travel_costs}? $c->{travel_costs}:($kilometerpauschale*$pat->{travel_distance}+($c->{travel_additional_costs} ||0.0));
                $c->{reisekosten}=sprintf("%3.2f EUR",$reisekosten);
                my $sql = SQL::Abstract->new;
                my($stmt, @bind) = $sql->update('patient_visits', {actual_costs=>$reisekosten}, {id=>$c->{id}});
                my $sthc = $self->db->prepare($stmt);
                $sthc->execute(@bind);
        
                $c->{visit_date}=~s/ 00:00:00$//ogs;
                $sum += $reisekosten;
                push @visits, $c;
            }
            $keyvaldict->{PAT_anrede}=$jsonR->{weiblich}?'Frau':'Herr';
            $keyvaldict->{visits}=\@visits;
            $keyvaldict->{reisekosten_sum}=sprintf("%3.2f EUR",$sum);
        }
    }
    my $data= pdfgen::PDFForTemplateAndRef(TempFileNames::readFile(form_repo_path.'/'. $formname.'.tex'), $keyvaldict);
    $self->render(data=> $data , format =>'pdf' );
};

get '/CT/serienbrief_patienten/:propid'=> [ propid =>qr/\d+/] => sub
{   my $self=shift;
    my $sessionid=$self->param('session');
    my $prop=$self->getObjectFromTable('trial_properties', $self->param("propid") );
    my $idtrial = $prop->{idtrial};

    my $dbh=$self->db;
    my $sql=qq{SELECT distinct piz, name, givenname, birthdate, anrede1, anrede2, street, zip, town, telephone, insertion_date FROM patient_identification_log where idtrial=? and ldap=? order by 1};
    my  %session;
    tie %session, 'Apache::Session::File', $sessionid , {Transaction => 0};
    my $ldap=$session{username};
    my $sth = $dbh->prepare( $sql );
    $sth->execute(($idtrial, $ldap));
    my @pats;
    my $keyvaldict=$self->getPropertiesDict($idtrial, $ldap);
    while(my $r=$sth->fetchrow_hashref())
    {
        for my $ckey (keys %$r) {
            $r->{$ckey}=~s/([0-9]+)-([0-9]+)-([0-9]+)/sprintf("%02d.",$3).sprintf("%02d.",$2).$1/oges;
        }
        push @pats, $r;
    }
    $keyvaldict->{patients}=\@pats;
    for my $ckey (keys %$keyvaldict) {
        $keyvaldict->{$ckey}=~s/([0-9]+)-([0-9]+)-([0-9]+)/sprintf("%02d.",$3).sprintf("%02d.",$2).$1/oges;
    }
    my $data= pdfgen::PDFForTemplateAndRef($prop->{value}, $keyvaldict);
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
get '/CT/new_patient/:idpatient' => [idpatient =>qr/[0-9]+/] => sub
{   my $self = shift;
    my $idpatient = $self->param('idpatient');
    my $idtrial= $self->getObjectFromTable('patients', $idpatient)->{idtrial};
    my $dbh=$self->db;
    my $stmt = 'select id as idreference_visit from trial_visits where idtrial=? and idreference_visit is  null limit 1';
    my $sth = $dbh->prepare($stmt);
    $sth->execute(($idtrial));
    my $outR=$sth->fetchall_arrayref();
    my $idreference_visit;
    $idreference_visit= $outR->[0]->[0] if $outR && scalar @$outR;
    my $currentDate=DateTime->now->ymd;
    $self->insertDictIntoTable('patient_visits', {idpatient=> $idpatient, visit_date=> $currentDate, idvisit=> $idreference_visit} ) if $idreference_visit && !$self->hasRow('patient_visits', {idpatient=> $idpatient, idvisit=> $idreference_visit} );
    $stmt = "insert into  patient_visits (idpatient, idvisit) select $idpatient as idpatient, trial_visits.id as idvisit from trial_visits left join patient_visits a on a.idvisit=trial_visits.id and a.idpatient=$idpatient where idtrial=? and idreference_visit is not null and trial_visits.id not in (?) and a.idvisit is null order by visit_interval";
    $sth = $dbh->prepare($stmt);
    $sth->execute(($idtrial, $idreference_visit));
    $self->render(text=>'OK');
};
post '/CT/new_ecrf/:idpatientvisit' => [idpatientvisit =>qr/[0-9]+/] => sub
{   my $self = shift;
    my $idpatientvisit = $self->param('idpatientvisit');
    my $idvisit= $self->getObjectFromTable('patient_visits', $idpatientvisit)->{idvisit};
    my $dbh=$self->db;
    my $stmt = qq{INSERT INTO visit_procedure_values (idvisit_procedure, idpatient_visit) ( SELECT visit_procedures.id as idvisit_procedure, ? as idpatient_visit
        FROM visit_procedures
        join procedures_catalogue on procedures_catalogue.id=idprocedure
        left join visit_procedure_values on visit_procedure_values.idvisit_procedure = visit_procedures.id and visit_procedure_values.idpatient_visit=?
        where visit_procedures.idvisit= ? and widgetclassname is not null and widgetclassname!='' and visit_procedure_values.id is null)};
    my $sth = $dbh->prepare($stmt);
    $sth->execute(($idpatientvisit,$idpatientvisit, $idvisit));
    $self->render(text=>'OK');
};
post '/CT/invite_teammeeting/:idteammeeting' => [idteammeeting =>qr/[0-9]+/] => sub
{   my $self = shift;
    my $idteammeeting = $self->param('idteammeeting');
    
    my $sessionid=$self->param('session');
    my  %session;
    tie %session, 'Apache::Session::File', $sessionid , {Transaction => 0};
    my $ldap=$session{username};
    
    my $dbh=$self->db;
    my $stmt = qq{ SELECT a.title, a.starttime, personnel_catalogue.email, personnel_catalogue.ldap
        FROM ( SELECT DISTINCT team_meetings.title, COALESCE(meeting_attendees.idattendee, group_assignments.idpersonnel) AS idpersonnel, team_meetings.starttime, team_meetings.stoptime
        FROM team_meetings
        JOIN group_assignments ON group_assignments.idgroup = team_meetings.idgroup
        LEFT JOIN meeting_attendees ON meeting_attendees.idmeeting = team_meetings.id) a
        JOIN personnel_catalogue ON personnel_catalogue.id = a.idpersonnel where team_meetings.id=?) };
    my $sth = $dbh->prepare($stmt);
    $sth->execute(($idteammeeting));
    while(my $c=$sth->fetchrow_hashref())
    {
    }
    
    my $calendar = Data::ICal->new();
    $calendar->add_properties(
    method      => "REQUEST",
    );
    my $event = Data::ICal::Entry::Event->new();
    $event->add_properties(
    summary     => "Subject",
    description => "FreeFormText.",
    dtstart     => Date::ICal->new( epoch => time )->ical,
    dtend       => Date::ICal->new( epoch => time +3 )->ical,
    dtstamp     => Date::ICal->new( epoch => time )->ical,
    class       => "PUBLIC",
    organizer   => "CN=Daniel:MAILTO:daboe01\@googlemail.com",
    attendee   => "ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=TRUE;CN=daniel:MAILTO:daniel.boehringer\@uniklinik-freiburg.de",
    location    => "Phone call",
    priority    => 5,
    transp      => "OPAQUE",
    sequence    => 0,
    uid         => "1234567",
    );
    $calendar->add_entry($event);
    
    my $data=$calendar->as_string;
    
    my $msg = MIME::Lite->new(
    From    =>'daboe01@googlemail.com',
    To      =>'daniel.boehringer@uniklinik-freiburg.de',
    Subject =>'Wichtiges Meeting!',
    Type    =>'multipart/mixed',
    );
    $msg->attach(
    Type    => "TEXT",
    Data    => "Wir muessen reden!\n",
    );
    
    my $part = MIME::Lite->new(
    Type	=> "text/calendar;  name=\"subject.ics\"",
    Filename	=> "subject.ics",
    Data        => $data,
    Encoding	=> 'base64',
    Disposition	=> 'attachment',
    );
    $msg->attr('content-class' => 'urn:content-classes:calendarmessage',
    'content-description' => "subject.ics",
    );
    $msg->attach($part);
    
    # $msg->send;
    
    $self->render(text=>'OK');
};

get '/CT/validate_iban/:idpatient' => [idpatient =>qr/[0-9]+/] => sub
{   my $self = shift;
    my $idpatient = $self->param('idpatient');
    my $dbh=$self->db;
    my $pat= $self->getObjectFromTable('patients', $idpatient); # <!> fixme: sanitize with session
    use Business::IBAN;
    my $iban_engine = Business::IBAN->new();
    my $iban=$pat->{iban};
    if($iban !~/DE/ogsi)
    {   $iban = $iban_engine->getIBAN(
        {   ISO  => 'DE',
            BIC => $pat->{bic},
            AC  => $iban,
        });
        $iban=~s/^IBAN //osi;
        my $sql = SQL::Abstract->new;
        my($stmt, @bind) = $sql->update('patients', {iban=>$iban}, {id=>$idpatient});
        my $sth = $self->db->prepare($stmt);
        $sth->execute(@bind);
    }
    my $bic=$pat->{bic};
    if($bic =~/^[0-9]+$/o)
    {   my $bank= $self->getObjectFromTable('bic_catalogue', $bic, undef,'blz');
        my $sql = SQL::Abstract->new;
        my($stmt, @bind) = $sql->update('patients', {bic=>$bank->{bic}, bank=>$bank->{name}}, {id=>$idpatient});
        my $sth = $self->db->prepare($stmt);
        $sth->execute(@bind);
    }

    $self->render(text=>  $iban_engine->valid($iban)? 'OK':'NOK'  );
};
        
get '/CT/reorder_visits/:idtrial' => [idtrial =>qr/[0-9]+/] => sub
{   my $self = shift;
    my $idtrial = $self->param('idtrial');
    my $dbh=$self->db;
    my $stmt = qq{update trial_visits set ordering=
        (select ordering from (select rank()  over (order by sortorder) as ordering,id from  ( select a.id, a.idtrial, coalesce(a.visit_interval,'0 days')+coalesce(b.visit_interval,'0 days') as sortorder from trial_visits a left join
         trial_visits b on a.idreference_visit=b.id) a where a.idtrial=?) a where a.id=trial_visits.id) where trial_visits.idtrial=?
    };
    my $sth = $dbh->prepare($stmt);
    $sth->execute(($idtrial, $idtrial));
    $self->render(text=>'OK');
};
        
get '/CT/travel_distance/:idpatient' => [idpatient =>qr/[0-9]+/] => sub
{   my $self = shift;
    my $idpatient = $self->param('idpatient');

    my $ua = Mojo::UserAgent->new;
    $ua->proxy->http(proxy_string);


    my $patient=$self->getObjectFromTable('patients', $idpatient);
    my $address=$patient->{street}.' '.$patient->{town};
    $address=~s/[\.0-9 -]+/+/ogs;
    my $url="http://maps.googleapis.com/maps/api/distancematrix/json?origins=".lc $address."&destinations=meinestr+meinestadt";
    my $data=$ua->get($url)->res->body;
        
    my $jsonR = decode_json($data );
    my $dist = $jsonR->{rows}->[0]->{elements}->[0]->{distance}->{text};
    $dist=~s/[^\.0-9]+//ogs;
    $dist  = ceil($dist)*2;   # hin und zurueck
    $self->render(text => $dist);
};


helper requiresProperty => sub { my ($self, $id, $property)=@_;
    my $dbh=$self->db;        
    my $sth = $dbh->prepare( qq/SELECT value~*'^[jY1]' as umsatzsteuer  FROM trial_properties JOIN trial_properties_catalogue ON trial_properties.idproperty = trial_properties_catalogue.id WHERE trial_properties_catalogue.name ~* ?::text and idtrial=?/);
    $sth->execute(($property, $id));
    my $r=$sth->fetchrow_hashref();
    return $r? ($r->{umsatzsteuer}) : 0;
};
helper getProperty => sub { my ($self, $idtrial, $property)=@_;
    my $dbh=$self->db;        
    my $sth = $dbh->prepare( qq/SELECT value FROM trial_properties JOIN trial_properties_catalogue ON trial_properties.idproperty = trial_properties_catalogue.id WHERE trial_properties_catalogue.name ~* ?::text and idtrial=?/);
    $sth->execute(($property, $idtrial));
    my $r=$sth->fetchrow_hashref();
    return $r? ($r->{value}) : undef;
};
        
helper hasRow => sub { my ($self, $table, $where)=@_;
    my $dbh=$self->db;        
    my $sql = SQL::Abstract::More->new;
    my($stmt, @bind) = $sql->select( -columns  => [qw/id/], -from => $table, -where => $where);
    my $sth = $self->db->prepare($stmt);
    $sth->execute(@bind);
    my $a=$sth->fetchall_arrayref();
    return scalar @$a;
};
        
get '/CT/trial_properties/:idtrial'=> [idtrial =>qr/\d+/] => sub
{   my $self=shift;
    my $idtrial = $self->param('idtrial');
    my $sessionid=$self->param('session');
    my  %session;
    tie %session, 'Apache::Session::File', $sessionid , {Transaction => 0};
    my $ldap=$session{username};
    my $keyvaldict=$self->getPropertiesDict($idtrial, $ldap);
    $self->render( json=> $keyvaldict );
};

post '/CT/make_bill/:idtrial'=> [idtrial =>qr/\d+/] => sub
{   my $self=shift;
    my $idtrial = $self->param('idtrial');
    my $idammendbill = $self->param('idammendbill');
    my $travelbill = $self->param('travelbill');
    my $sessionid=$self->param('session');
    my  %session;
    tie %session, 'Apache::Session::File', $sessionid , {Transaction => 0};
    my $ldap=$session{username};
    my $filter = $self->req->body;
       $filter=~s/[, ]+$//ogs;
    my $keyvaldict=$self->getPropertiesDict($idtrial, $ldap);
    my $requires_ust=$self-> requiresProperty($idtrial,'umsatzst');
    my $overhead_inclusive=$self-> requiresProperty($idtrial,'overhead');

    my $sql = SQL::Abstract::More->new;
    $idtrial = $idtrial=~/^([0-9]+)$/? $1: undef;
    $idammendbill = $idammendbill=~/^([0-9]+)$/? $1: undef;
    my $where;
    if($idammendbill)
    {   $where.=" id in ($1)" if $filter =~/(^[0-9, ]+$)/;
    } else
    {
        $where = "idtrial = $idtrial";
        $where.=" and idpatient in ($1)" if $filter =~/(^[0-9, ]+$)/;
    }
    my($stmt, @bind) = $sql->select( -columns  => [qw/id idtrial visit_date code1 code2 visit reimbursement/], -from => $travelbill? 'list_for_travelbilling':'list_for_billing', -where => $where, -order_by=>[qw/code1 code2 visit_date/]);
    my $sth = $self->db->prepare($stmt);
    $sth->execute(@bind);
    my $sum=0;
    my $idstr='';
    while(my $c=$sth->fetchrow_hashref())
    {   $sum+=$c->{reimbursement};
        $idstr.=$c->{id}.', ';
    }
    if(!$travelbill){
        my $overhead= $overhead_inclusive? 0: $sum*0.25;    # FIXME: 25% overhead should be a constant
        $sum+=$overhead;
        my $ust= $requires_ust? $sum*0.19: 0;      # FIXME: 19% UST should be a constant
        $sum+=$ust;
    }
    if($idammendbill)
    {
        my $bill=$self->getObjectFromTable('billings', $idammendbill);
        my $update = SQL::Abstract->new;
        my $newamount = sprintf('%4.2f',$sum+$bill->{amount}+0);
        my ($stmt, @bind) = $update->update( 'billings', {amount=> $newamount, comment=> sprintf('%4.2f EUR',$newamount), visit_ids=>$bill->{visit_ids}.$idstr}, {id=> $idammendbill});
        $sth = $self->db->prepare($stmt);
        $sth->execute(@bind);
    } else
    {
        my $insert = SQL::Abstract->new;
        my ($stmt, @bind) = $insert->insert( 'billings', {idtrial=>$idtrial, amount=> sprintf('%4.2f',$sum), comment=> sprintf('%4.2f EUR',$sum), ($travelbill? 'visit_ids_travel_costs':'visit_ids')=>$idstr});
        $sth = $self->db->prepare($stmt);
        $sth->execute(@bind);
    }
    $self->render( text=> 'OK' );
};
get '/CT/iCAL/:ldap'=> [ldap =>qr/[a-z_0-9]+/i] => sub
{
    my $self=shift;
    my $personal=$self->param('personal');
    my $ldap = $self->param('ldap');
	my $sql="SELECT  distinct name, event_date, tooltip || ' (' || piz ||')' as description  from event_overview where ".($personal?"ldap":"ldap_unfiltered")."=? and not name~*'^dummy '";
	my $sth = $self->db->prepare( $sql );
	$sth->execute(($ldap));
  	my $rowarrref;
	my $calendar = Data::ICal->new();
    
    my $vtimezone = Data::ICal::Entry::TimeZone->new();
    $vtimezone->add_properties( tzid => 'Europe/Berlin', tzname=>'CEST');
    $calendar->add_entry($vtimezone);
    
    sub icalDateForDate { my ($date, $mysec)=@_;
        my ($year,$month,$day,$hour,$min,$sec)= $date=~ /([0-9]+)-([0-9]+)-([0-9]+) ([0-9]+):([0-9]+):([0-9]+)/;
        if($hour+$min+$sec == 0)
        {	my $date= DateTime->new( year => $year, month => $month, day => $day, hour => $hour, minute => $min, second => 1 );
            return $date->strftime('%Y%m%d');
        } else
        {	return Date::ICal->new( year => $year, month => $month, day => $day, hour => $hour, min => $min, sec => $mysec )->ical;
        }
    }
    
    my $i;
	while($rowarrref=$sth->fetchrow_arrayref() )
	{
        my $piz=$1 if $rowarrref->[2]=~/([0-9]{8})/;
		my $vevent = Data::ICal::Entry::Event->new();
		$vevent->add_properties(
        summary => ucfirst $rowarrref->[2].' '.$rowarrref->[0],
        uid=> 'iclinical_'. DateTime->now->epoch.'_'.$i++,
        description => $piz? "http://augimageserver/Viewer/?$piz":$rowarrref->[2],
        dtstart   =>  icalDateForDate($rowarrref->[1] , 1),
        dtend   =>  icalDateForDate($rowarrref->[1], 2)
        );
		$calendar->add_entry($vevent);
	}
    $self->render( text=> $calendar->as_string );
};

###################################################################
# to be factored out
#<!> fixme: this ugly stuff should be factored out in a driver module
get '/CT/print_bill/:idbill'=> [idbill =>qr/\d+/] => sub
{   my $self=shift;
    my $idbilling = $self->param('idbill');
    my $sessionid=$self->param('session');
    my  %session;
    tie %session, 'Apache::Session::File', $sessionid , {Transaction => 0};
    my $ldap=$session{username};

    my $hash=$self->getObjectFromTable('billings', $idbilling);
    my $idtrial=$hash->{idtrial};
    use Spreadsheet::WriteExcel;
    my $keyvaldict=$self->getPropertiesDict($idtrial, $ldap);
        
    use Spreadsheet::ParseExcel;
    use Spreadsheet::ParseExcel::SaveParser;

    my $parser   = new Spreadsheet::ParseExcel::SaveParser;
    my $template = $parser->Parse(form_repo_path.'/'. 'Rechnungserstellung.xls');

    # Get the worksheet
    my $worksheet = $template->worksheet(0);
    my $cell = $worksheet->get_cell( 33, 0 );
    my $formatfooter_number = $cell->{FormatNo};
    $cell = $worksheet->get_cell( 33, 6 );
    my $formatfooter_number2 = $cell->{FormatNo};
    $cell = $worksheet->get_cell( 32, 6 );
    my $format_number = $cell->{FormatNo};

    $template->AddCell( 0, 6, 3, $keyvaldict->{_Loginname_} );
    $template->AddCell( 0, 7, 3, "Augenklinik" );
    $template->AddCell( 0, 8, 3, "Klinische Studien" );
    $template->AddCell( 0,12, 3, $keyvaldict->{Sponsor} );
    $template->AddCell( 0,14, 3, $keyvaldict->{Monitor} );
    $template->AddCell( 0,19, 3, $keyvaldict->{'USt-ID'} );
    $template->AddCell( 0,28, 3, $keyvaldict->{Drittmittelnummer} );
    $template->AddCell( 0,29, 3, $keyvaldict->{'Voller Titel'} );

    my $bill=$self->getObjectFromTable('billings', $idbilling);

    my $requires_ust=$self-> requiresProperty($idtrial,'umsatzst');
    $requires_ust=0 if $bill->{visit_ids_travel_costs};
    my $overhead_inclusive=$self-> requiresProperty($idtrial,'overhead');
    $overhead_inclusive=1 if $bill->{visit_ids_travel_costs};


    my $sql = SQL::Abstract::More->new;
    my($stmt, @bind) = $sql->select( -columns  => [qw/id idtrial visit_date code1 code2 visit reimbursement/], -from => $bill->{visit_ids_travel_costs}? 'travel_billing_print': 'billing_print', -where => {idbilling => $idbilling}, -order_by=>[qw/code1 code2 visit_date/]);
    my $sth = $self->db->prepare($stmt);
    $sth->execute(@bind);
    my $i=32;
    my $sum=0;
    my $idstr='';
    my $start_i=$i;
    while(my $c=$sth->fetchrow_hashref())
    {   $c->{visit_date}=~s/00:00:00//ogs;
        $template->AddCell( 0,$i, 0, $c->{code1}.' '.$c->{code2}.' '.$c->{visit} );
        $template->AddCell( 0,$i, 1, '');
        $template->AddCell( 0,$i, 2, '');
        $template->AddCell( 0,$i, 3, $c->{visit_date});
        $template->AddCell( 0,$i, 4, '1');
        $template->AddCell( 0,$i, 5, $c->{reimbursement}, $format_number);
        $template->AddCell( 0,$i, 6, $c->{reimbursement}, $format_number);
        $i++;
        $sum+=$c->{reimbursement};
        $idstr.=$c->{id}.', ';
    }
    $template->AddCell( 0,$i, 0, 'Summe', $formatfooter_number);
    $template->AddCell( 0,$i, $_, '', $formatfooter_number) for 1..5;
    my $range="G$start_i:G$i";
    $template->AddCell( 0,$i, 6, '=SUM(' . $range . ')', $formatfooter_number2);
    my $overhead= $overhead_inclusive? 0: $sum*0.25;    # FIXME: 25% overhead should be a constant
    if($overhead)
    {   $sum+=$overhead;
        $i++;
        $template->AddCell( 0,$i, 0, 'Overhead', $formatfooter_number);
        $template->AddCell( 0,$i, $_, '', $formatfooter_number) for 1..5;
        my $range="G$i";
        $template->AddCell( 0,$i, 6, '='.$range . '*0.25', $formatfooter_number2);
    }
    $start_i=$i;
    my $ust= $requires_ust? $sum*0.19: 0;      # FIXME: 19% UST should be a constant
    if($ust)
    {   $i++;
        $sum+=$ust;
        $template->AddCell( 0,$i, 0, 'Ust. 19 Prozent', $formatfooter_number);
        $template->AddCell( 0,$i, $_, '', $formatfooter_number) for 1..5;
        my $range='G'.($i- ($overhead?1:0) ).':G'.$i;
        $template->AddCell( 0,$i, 6, '=SUM(' . $range . ')*0.19', $formatfooter_number2);
    }
    $i++;
    $range='G'.($start_i+ ($overhead?0:1) ).':G'.$i;

    $template->AddCell( 0, $i, 0, 'Rechnungsbetrag', $formatfooter_number);
    $template->AddCell( 0, $i, $_, '', $formatfooter_number) for 1..5;
    $template->AddCell( 0, $i, 6, '=SUM(' . $range . ')', $formatfooter_number2);
    
    my $tmpfilename=tempFileName('/tmp/dbweb','xls');
    $template->SaveAs($tmpfilename);
    my $xls=readFile ($tmpfilename);
    $self->render_file('data' => $xls, 'format'   => 'xls', 'filename' => 'rechnung.xls');
};


any '/CT/print_visit_ecrf/:idpatientvisit'=> [idpatientvisit =>qr/\d+/] => sub
{   my $self=shift;
    my $idpatientvisit = $self->param('idpatientvisit');
    my $sessionid=$self->param('session');

    my  %session;
    tie %session, 'Apache::Session::File', $sessionid , {Transaction => 0};
    my $ldap=$session{username};

    my $sql=qq{SELECT idtrial, patients.code1, patients.code2, visit_date, value_full, coalesce(ecrf_name, procedures_catalogue.name) as name, procedures_catalogue.latex_representation
               FROM visit_procedure_values join visit_procedures on visit_procedures.id=idvisit_procedure
               join procedures_catalogue on idprocedure=procedures_catalogue.id
               join patient_visits on patient_visits.id=visit_procedure_values.idpatient_visit
               join patients on patients.id=idpatient
               where patient_visits.id=?
               order by ordering};
    my $sth = $self->db->prepare( $sql );
    $sth->execute(($idpatientvisit));
    my @values;
    my $sum=0;
    while(my $c=$sth->fetchrow_hashref())
    {
        if ($c->{latex_representation})
        {   my $h = $c->{value_full}? decode_json($c->{value_full}) :{};
            $c->{value} = pdfgen::expandPDFDict($c->{latex_representation}, $h);
        } else
        {
            $c->{value}= $c->{value_full};
        }
        push @values, $c;
    }
    my $idtrial=$values[0]->{idtrial};
    my $keyvaldict=$self->getPropertiesDict($idtrial, $ldap);
    $keyvaldict->{values} = \@values;
    $keyvaldict->{code1} =$values[0]->{code1};
    $keyvaldict->{code2} =$values[0]->{code2};
    $keyvaldict->{visit_date} =$values[0]->{visit_date};
    my $data= pdfgen::PDFForTemplateAndRef(TempFileNames::readFile(form_repo_path.'/ecrf_template.tex'), $keyvaldict);
    $self->render(data=> $data , format =>'pdf' );
};


###################################################################
# main()

app->config(hypnotoad => {listen => ['http://*:3004'], workers => 10, proxy => 1, heartbeat_timeout=>1200, inactivity_timeout=> 1200});
app->start;
