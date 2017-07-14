use strict;
use warnings;

use XML::Simple;
use Net::FTP;


sub xml_upload {
	my ($host, $user, $pass, $dir, $fpath) = @_;
	my $ftp;

	$ftp = Net::FTP->new($host, Debug => 0);
	$ftp->login($user, $pass) || die $ftp->message;
	$ftp->cwd($dir);
	$ftp->put($fpath) || die $ftp->message;
	$ftp->quit;

	print $ftp->message;
}

sub password_creation {
		my $sel = WWW::Selenium->new( host => "localhost",
		port => 4444,
		browser => "*iexplore",
		browser_url => "http://www.google.com",
		);

	$sel->start;
	$sel->open("http://www.google.com");
	$sel->type("q", "hello world");
	$sel->click("btnG");
	$sel->wait_for_page_to_load(5000);
	print $sel->get_title;
	$sel->stop;
}
