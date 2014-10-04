package TempFileNames;
require 5.000;
require Exporter;

@ISA       = qw(Exporter);
@EXPORT    = qw(&tempFileName &removeTempFiles &readCommand &readFile &writeFile &scanDir &copyTree &dirList &searchOutputPattern &normalizedPath &relativePath &quoteRegex &uniqFileName &readStdin &restoreRedirect &redirectInOut &germ2ascii &appendStringToPath &pipeStringToCommand &pipeStringToCommandSystem &mergeDictToString $DONT_REMOVE_TEMP_FILES &readFileHandle &trimmStr &deepTrimmStr &removeWS &fileLength &processList &pidsForWordsPresentAbsent &initLog &Log &cmdNm &splitPath &resourcePath &resourcePathesOfType &splitPathDict &percentagePrint &firstFileLocation &readFileFirstLocation &allowUniqueProgramInstanceOnly &write2Command &loadTableFile);
#@EXPORT_OK = qw($sally @listabob %harry func3);

#use lib '/LocalDeveloper/Libraries/perl5';
use File::Copy;
use File::Path;
use IO::Handle;
#use Locale;	# dependence is: germ2ascii <i><A> tb removed
#	germ2ascii has been moved to Locale.pm this will break some code <!>

BEGIN { srand(); $DONT_REMOVE_TEMP_FILES=0; }
sub uniqFileName {	my($prefix)=@_;
	my($i);
	if (!-e $prefix) { return $prefix; }
	for ($i=0; -e ($ret=$prefix."_$i"); $i++) { }
	return $ret;
}

sub tempFileName { my ($prefix, $postfix) = @_;
	my $ret;
	while (-e ($ret = $prefix. int(rand(1000000)). $postfix)) { print $ret."\n" if(0); }
	push(@tempFileList, $ret);
	return $ret;
}
#sub removeTempFiles { system('rm -f '.join(' ',@tempFileList)) if ($#tempFileList>=0); }
sub removeTempFiles { unlink(@tempFileList);
}

END { removeTempFiles() if (!$DONT_REMOVE_TEMP_FILES); }	# perl shutdown

sub resourcePath { my ($resource) = @_;
	foreach $path (@INC)
	{
		return "$path/$resource" if (-e "$path/$resource");
	}
	return undef;
}
sub resourcePathesOfType { my ($resource, $type, $subPath) = @_;
	my ($list, $thisPath) = ([]);
	foreach $path (@INC)
	{	$thisPath = defined($subPath)? "$path/$subPath": $path;
		push(@{$list}, map { "$thisPath/$_"; } grep(/\.$type$/, dirList($thisPath)));
	}
	return $list;
}
sub firstFileLocation { my ($filePath, @dirs) = @_;
	my $p = splitPathDict($filePath);
	# <!> changed [23.8.2003]: $p->{base} -> $p->{basePath}
	foreach $file ($filePath, map { "$_/$p->{basePath}.$p->{extension}" } @dirs) {
		return $file if -e $file;
	}
	return undef;
}
sub readFileFirstLocation { my ($filePath, @dirs) = @_;
	return readFile(firstFileLocation($filePath, @dirs));
}

sub handleLength { my ($handle)=@_;
	my ($orig, $len)=(tell($handle));
	seek($handle,0,2), $len=tell($handle), seek($handle,$orig,0);
	return $len;
}
sub fileLength { my ($path)=@_;
	open(__PATHLENGTH, $path);
	my $length=handleLength(\*__PATHLENGTH);
	close(__PATHLENGTH);
	return $length;
}
sub readCommand { my ($command) = @_;
	return undef if (!open(COMMANDOUTPUT, "$command|"));
	my $buffer = '';
	while (<COMMANDOUTPUT>) { $buffer .= $_; }
	close(COMMANDOUTPUT);
	return $buffer;
}
sub write2Command { my ($command, $input) = @_;
	return undef if (!open(PP_COMMAND, "|$command"));
	print PP_COMMAND $input;
	close(PP_COMMAND);
}

sub readFile { my($path)=@_;
	return undef if ((! -e $path && !($path =~ m{[|<>]}o)) || !open(READFILE,$path));
	my $buffer = '';
	read(READFILE,$buffer, handleLength(\*READFILE),0);
	close(READFILE);
	return $buffer;
}
sub writeFile { my ($path, $buffer, $doMakePath, $fileMode, $dirMode)=@_;
	if ($doMakePath)
	{	$path=~m{(.*)/[^/]+}o;
		if ($dirMode) { mkpath($1, 0, $dirMode); }
		else { mkpath($1, 0); }
	}
	return undef if (!open(WRITEFILE, ">$path"));
	syswrite(WRITEFILE, $buffer, length($buffer), 0);
	close(WRITEFILE);
	chmod($fileMode, $path) if ($fileMode); # chmod needs umask
}
sub readStdin { my($ret);
	while (defined($_ = <STDIN>)) { $ret.=$_; }
	return $ret;
}
sub readFileHandle { my ($typeGlobRef)=@_;
	my($ret);
	while (defined($_ = <$typeGlobRef>)) { $ret.=$_; }
	return $ret;
}
sub readFileByLines { my($path)=@_;
	return undef if (!open(READFILE,$path));
	my $buffer = '';

	while (defined($_ = <READFILE>)) { $buffer .= $_; }
	close(READFILE);
	return $buffer;
}

sub searchOutputPattern { my ($pattern,$cmd)=@_;
	my ($tmpfile,$outp)=tempFileName('/tmp/searchoutp');
	system("$cmd > $tmpfile");
	$outp=readFile($tmpfile);
	unlink($tmpfile);
	return $outp=~s/$pattern//g;
}

# sub fct { my($dstPath,$srcPath,$object,$basePath)=@_;

sub	scanDir { my($dstPath,$basePath,$path,$fct,$obj)=@_;
	my ($postfix,@list,$ret);
	opendir(DIR, $path);	# || die "can't opendir $some_dir: $!";
		@list = readdir(DIR);
		splice(@list,0,2);	# chop off '.', '..'
	closedir(DIR);
	$postfix=substr($path,length($basePath));
	#print "Welcome to ScanDir scanning($path) Pathpostfix:$postfix Dst:$dstPath\n";
	while ($object=shift(@list))
	{	$ret=&{$fct}($dstPath.$postfix,$path,$object,$basePath,$obj);
		scanDir($dstPath,$basePath,$path.'/'.$object,$fct,$obj)
			if (!$ret && -d $path.'/'.$object && !$isRel);
	}
}

sub copyFiles { my($dstPath,$srcPath,$object,$basePath,$filter)=@_;
	my($readPath,$writePath,$d,$ino,$mode,$nlink);
	$readPath=$srcPath.'/'.$object;
	$writePath=$dstPath.'/'.$object;

	($d,$ino,$mode,$nlink,$d,$d,$d,$d,$d,$d,$d,$d,$d)=lstat($readPath);
	if (&{$filter}($readPath))
	{	if (-d $readPath)
		{	print STDERR "Couldn't create $writePath\n" if (!mkpath($writePath,0,0775));
		} else {
			copy($readPath,$writePath,1024*1024);
			#chmod($mode,$writePath);
		}
	}
	return 0;
}

sub copyAll { return 1; }

sub copyTree { my($dstPath,$srcPath,$filterFct)=@_;
	$filterFct=\&copyAll if (!defined($filterFct));
	scanDir($dstPath,$srcPath,$srcPath,\&copyFiles,$filterFct);
}

sub processList {
	open (__PS, "ps -ax|");
		my $list=readFileHandle(\*__PS);
	close(__PS);
	return $list;
}
sub pidsForWordsPresentAbsent { my ($presentWord, $absentWord)=@_;
	my (@prcs, $prcs,$process, @selected);
	@prcs=($prcs=processList())=~m{^\s*[0-9]+.*$presentWord.*$}ogm;
	foreach $process (@prcs)
	{	next if (defined($absentWord) && $process=~m{$absentWord});
		($pid)=$process=~m{\s*([0-9]+)}o;
		push(@selected, $pid);
	}
	return @selected;
}

sub dirList { my($path)=shift;
	my @list;
	opendir(DIRLISTFH, $path);	# || die "can't opendir $some_dir: $!";
		@list = readdir(DIRLISTFH);
		splice(@list,0,2);	# chop off '.', '..'
	closedir(DIRLISTFH);
	return @list;
}
sub normalizedPath { my($path, $sep, $doSlashes, $beURLaware)=@_;
	# URLawareness means that m{[a-z]+//:} will be skipped
	if ($doSlashes)	# if ($beURLaware) then exclude the double slashed url-qualifier
	{
		if ($beURLaware) { my ($type, $protocol, $urlPath) = ($path =~ m{(([a-z]+:)?//)?(.*)}o);
			$urlPath =~ s{/+}{/}go;
			$path = $type.$urlPath;
#			$path = ($protocol ne ''? $protocol: 'http:')."//$urlPath";
#		if ($beURLaware) { my ($type, $urlPath) = ($path =~ m{([a-z]+://)?(.*)}o);
#			$urlPath =~ s{/+}{/}go, $path = $type.$urlPath;
		} else { $path=~s{/+}{/}go; }		#mult slashes are like single slashes
	}
	# . elimination before .. dt .. must ignore any .
	#	eliminate . components: here seems to be some bug <b>
	$path=~s{(^|/)\./}{\1}og;				#g option is safe here (dt limited scope)
	while ($path=~s{(^|/)[^/]*/\.\./}{\1}o) {}	#<A><b> succeding '..' prevent g option
	return $path;
}
sub relativePath { my($absCurr, $absDest, $sep, $ignoreCase)=@_;
	#	trailing null fields are stripped
	my ($curS,$curD)=(normalizedPath($absCurr), normalizedPath($absDest));
	my @curr=($curS eq $sep)? (''): split(/$sep/, $curS);
	my @dest=($curD eq $sep)? (''): split(/$sep/, $curD);
	my $i,$app;
#print "Path:",join('|',@curr),"\n";
	for ($i=0; $i<=$#curr; $i++)
	{
		if ($ignoreCase) {
			last if (lc($curr[$i]) ne lc($dest[$i]));
		} else {
			last if ($curr[$i] ne $dest[$i]);
		}
	}
	$app=(((chop($curD) eq $sep) && ($#dest-$i>=0))? $sep: '');
	return "..$sep" x ($#curr-$i).join($sep,splice(@dest,$i)).$app;
}

sub quoteRegex { return join('\\',split(/(?=\.|\?|\=|\*|\\)/,$_[0])); }

sub redirectInOut { my($saveName, $inPath, $outPath)=@_;
	open($saveName.'OUT', ">&STDOUT");
	open($saveName.'IN', "<&STDIN");
	open(STDIN, $inPath);
	open(STDOUT, ">$outPath");
}
sub restoreRedirect { my($saveName)=@_;
	close(STDIN);
	close(STDOUT);
	open(STDIN, "<&$saveName".'IN');
	open(STDOUT, ">&$saveName".'OUT');
}

sub germ2ascii { my($str)=@_;
	die "germ2ascii has been moved to Locale.pm\nAdd 'use Locale' after 'use TempfileNames.";
}

sub appendStringToPath { my ($strRef, $path)=@_;
#	print "Will append to path:$path\n";
	open(APPEND_HANDLE, ">>$path");
		print APPEND_HANDLE $$strRef;
	close(APPEND_HANDLE);
}
sub pipeStringToCommand { my ($strRef, $cmd)=@_;
#	print "Will pipe through:$cmd\n";
	open(PIPE_HANDLE, "|$cmd");
		print PIPE_HANDLE $$strRef;
	close(PIPE_HANDLE);
}
sub pipeStringToCommandSystem { my ($strRef, $cmd)=@_;
	my $tmpFile=tempFileName('/tmp/mail');
	writeFile($tmpFile, $$strRef);
#	system("cat $tmpFile| $cmd ; echo >/dev/console '$tmpFile written'");
	system("$cmd < $tmpFile >/dev/console 2>&1");
}

sub mergeDictToString { my($hash, $str, $flags)=@_;
	my @keys = keys(%{$hash});
	if (uc($flags->{sortKeys}) eq 'YES')
	{	@keys = sort { length($b) <=> length($a); } @keys;
	}
	if (uc($flags->{keysAreREs}) eq 'YES')
	{	foreach $key (@keys)
		{	$str=~s/$key/$hash->{$key}/g;
		}
	} else {
		foreach $key (@keys)
		{	$str=~s/\Q$key\E/$hash->{$key}/g;
		}
	}
	return $str;
}

sub trimmStr { my($str)=@_;	#remove whitespace at both ends of string
	$str=~s/^\s+|\s+$//g;
	return $str;
}

#	remove whitespace at both ends of string, collapse to single space inside
sub deepTrimmStr { my($str)=@_;
	$str=~s/^\s+|\s+$//og;
	$str=~s/\s+/ /og;
	return $str;
}
sub removeWS { my($str)=@_;	#remove all whitespace inside string
	$str=~s/\s+//og;
	return $str;
}

#	<p> log level conventions
#	Lev	Comment
#-----------------------------------------------------------------------
#	0	nothing is logged
#	1	may be logged on regular use [<10 lines per app call]
#	2	end user information which may be logged with a verbose flag
#	3	more verbosity: still user information
#	4	debugging information which may be turned on on regular usage
#	5	development only logging
#	6	debugging only logging: app becomes unusable on regular usage
#	>6	think what you want

#	<g> global here: $__verbosity, $__logPrefix
sub initLog { my ($verbosityLevel)=@_;
	$__verbosity = $verbosityLevel;
	$0 =~ /[^\/]+$/o;
	$__logPrefix = $&."[$$]: ";
}

# <!> 4.7.2001: this is hard change: log -> Log not to overwrite the internal function
sub Log { my ($message, $level)=@_;
	initLog(1) if (!defined($__verbosity));
	$level = 1 if (!defined($level));
	return if ($level > $__verbosity);
	print STDERR $__logPrefix.$message."\n";
}

sub cmdNm { $0=~m{/([^/]*)$}o; return $1; }

#	SplitPath options
# 		$doTestDir makes splitPath to probe the path on Dir Qualitiy
#		if so the whole path is the dir and $fileNameToSubstitue is the filename

sub splitPath { my ($path, $doTestDir, $fileNameToSubstitue)=@_;
	my ($directory, $filename, $ext);
	if ($doTestDir && -d $path)
	{	($directory, $filename, $ext) =
			($path, $fileNameToSubstitue =~ m{^(.*?(?:\.([^/.]*))?)$}o );
	} else {
		($directory, $filename, $ext) = ($path =~ m{^(?:(.*)/)?([^/]*?(?:\.([^/.]*))?)$}o);
	}
	return ($directory, $filename, $ext);
}

sub splitPathDict { my ($path, $doTestDir, $fileNameToSubstitue)=@_;
	my ($directory, $filename, $ext) = splitPath($path, $doTestDir, $fileNameToSubstitue);
	my $base = defined($ext)? substr($filename, 0, - length($ext) - 1): $filename;
	my $dirPrefix = defined($directory)? "$directory/": '';

	return { dir => $directory, base => $base, extension => $ext, file => $filename,
		path => $path, basePath => $dirPrefix.$base };
}

#
#	some (loosly) file related output methods
#

sub percentagePrint { my ($count, $max, $hashCount, $file) = @_;
	my $p = $count / $max;
	$hashCount = 20 if (!defined($hashCount));
	$file = \*STDERR if (!defined($file));
	printf $file '['.("#" x int($p * $hashCount + 0.5)).
		(" " x ($hashCount - int($p * $hashCount + 0.5)))."] %d%% (%d)\r",
		int($count * 100 / $max + 0.5), $count;
	$file->flush();
}


sub allowUniqueProgramInstanceOnly {
	my ($name) = ($0 =~ m{/?([^/]*)$}o);
	my $processes = readCommand("ps auxw");
	my @instances = ($processes =~ m{\Q$name\E}og);

	if (@instances > 1) {
		Log("An instance of $name is already running. Exiting.");
		exit(0);
	}
}

sub loadTableFile { my($path,$columnPath,$primaryKey,$splite)=@_;
	my $data=readFile($path);
	my $columsData=readFile($columnPath) if(length $columnPath);
	my @datarows=(split /\n/,$data);
	my $entitiesRef=[];
	my $row_indexRef={};
	my $column_indexRef={};
	my $column;
	my @columns;

	$splite="\t" unless(defined $splite);

	if(length $columsData)
	{	@columns=(split /\n/,$columsData);
	} else
	{	my $firstline=shift @datarows;
			@columns=(split /$splite/,$firstline);
	}
	my $i=0; map { $column_indexRef->{$_}=$i++ } (@columns);

	my $i=0; my $entity;
	foreach $entity (@datarows)
	{	my @attribs=(split /$splite/,$entity );
			push @{$entitiesRef},\@attribs;
	}
	my $i=0;
	foreach $entity (@{$entitiesRef})
	{ $row_indexRef->{$entity->[$column_indexRef->{$primaryKey}]}=$i++;
	}
	return ($entitiesRef,$row_indexRef,$column_indexRef);
}

1;
