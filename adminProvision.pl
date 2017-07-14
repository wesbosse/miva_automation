use strict;
use warnings;

use XML::Simple;
use Net::FTP;


sub xml_upload {
	my ($host, $user, $pass, $dir, $fpath) = @_;
	my $ftp;


	$ftp = Net::FTP->new($host, Debug => 1);
	$ftp->login($user, $pass) || die $ftp->message;
	$ftp->cwd($dir);
	$ftp->put($fpath) || die $ftp->message;
	$ftp->quit;

	print $ftp->message;
}

sub password_creation {
		my $sel = WWW::Selenium->new( 	
			host => "localhost",
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

print "FTP Host:\n";
my $input_ftp_host = <STDIN>;
print "FTP Username:\n";
my $input_ftp_user = <STDIN>;
print "FTP Password:\n";
my $input_ftp_pass = <STDIN>;
print "Dev Key:\n";
my $input_dev_key = <STDIN>;
print "Dev Account Password:\n";
my $input_dev_pass = <STDIN>;

my $pre_provide_file_location = '/Users/WBosse/Desktop/merica.png';
my $destination_directory = '/htdocs/mm5/test'

chomp($input_ftp_host,$input_ftp_user,$input_ftp_pass,$input_dev_key,$input_dev_pass);

xml_upload(
	$input_ftp_host,
	$input_ftp_user, 
	$input_ftp_pass,
	$destination_directory,
	$pre_provide_file_location
);