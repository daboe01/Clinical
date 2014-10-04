#!/usr/bin/perl
use lib qw{/Users/Shared/bin/};	#mac/linux
use TempFileNames;

# 11.5.05 by dr. boehringer

package pdfgen;

sub expandPDFDict { my ($block,$dict)=@_;
	foreach my $key (keys %{$dict})
	{	if( ref($dict->{$key}) eq 'ARRAY' )
		{	$block =~s/<foreach:$key\b([^>]*)>(.+?)<\/foreach:$key>/expandPDFForeachs ($2, $dict->{$key}, $1)/iegs;		# without workaround
		} else
		{	$dict->{$key} =~s/([<>])/ \$$1\$ /igs;
			$dict->{$key} =~s/(?<!\\)%/\\%/gs;	#Negative Lookbehind
			$block =~s/<\Q$key\E>/$dict->{$key}/iegs;
		} 
	} return $block;
}
sub expandPDFForeachs { my ($block,$arr, $sepStr)=@_;
	my $sep;
	$sep=$1 if($sepStr=~/sep=\"(.*?)\"/ois);
	my @ret=map { expandPDFDict($block,$_) } (@{$arr});
	@ret=grep { !/^\s*$/ } @ret;
	return join ($sep, @ret);
}

sub copyTexToTemp { my ($name)=@_;
	warn $name;
	system("cp /Users/Shared/bin/Clinical/forms/$name /tmp/$name");
	return $name;
}

sub PDFFilenameForTemplateAndRef { my ($str, $objc)=@_;
	if(ref($objc) eq 'ARRAY')
			{	$str =~s/<foreach>(.*?)<\/foreach>/expandPDFForeachs($1,$objc)/oegs }
	else 	{	$str = expandPDFDict($str,$objc)}
	$str =~s/<copytex:([^>]+)>/copyTexToTemp($1)/oegs;
	use Data::Dumper;
warn Dumper $objc;
	my $tmpfilename=TempFileNames::tempFileName('/tmp/clinical','');
	TempFileNames::writeFile($tmpfilename.'.tex',$str);
	$main::ENV{PATH} = '/usr/texbin'; 								#untaint
	# system('cd /tmp; /usr/texbin/pdflatex --interaction=batchmode  '.$tmpfilename.'.tex ');
    system('cd /tmp; export PATH="/usr/local/bin:$PATH"; /usr/texbin/xelatex --interaction=batchmode '.$tmpfilename.'.tex ');
	return $tmpfilename.'.pdf';
}

sub PDFForTemplateAndRef { my ($str,$objc)=@_;
	my $filename=PDFFilenameForTemplateAndRef($str,$objc);
	my $data=TempFileNames::readFile( $filename);
	return $data;
}

sub LPRPrint { my ($data, $printer, $copies, $options)=@_;
	my $prn="/usr/bin/lpr -P $printer -# "."$copies -o $options ";
	my $tmpfilename= TempFileNames::tempFileName('/tmp/dbweb', '');
	TempFileNames::writeFile($tmpfilename, $data );
	$main::ENV{PATH} = '/usr/bin'; 								#untaint

	system($prn.$tmpfilename);

}
1;
