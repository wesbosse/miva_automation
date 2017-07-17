# 701497
use strict;
use warnings;

use XML::Simple;
use Data::Dumper;
use Net::FTP;
use WWW::Mechanize;

sub pre_provide_manipulation {
	# create object
	$xml = new XML::Simple;

	# read XML file
	$pre_provide = $xml->XMLin("pre-provide.xml");

	# print output
	print Dumper($pre_provide);
}

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
 	my $mech = WWW::Mechanize->new;  
	my $sequence = '...';
	# $mech->get('https://'.$sub.$name'.com/Merchant2/admin.mvc');
	$mech->get('https://dts3100.mivamerchantdev.com/mm5/admin.mvc');
	$mech->submit_form(
		form_number => 0,
		fields => {
			'UserName' => 'wbosse@miva.com',
			'PassWord' => '',
		},
	);
	# my $mech = WWW::Mechanize->new;  
	# my $sequence = '...';
	# $mech->get('https://'.$sub.$name'.com/Merchant2/admin.mvc');
	# $mech->submit_form(
	# 	form_number => 0,
	# 	fields => {
	# 		'UserName' => 'support_wbosse',
	# 		'PassWord' => '',
	# 	},
	# );

	print $mech->content;
}



# Testing Variables
my $pre_provide_file_location = '/Users/WBosse/Desktop/merica.png';
my $destination_directory = '/mivadata/mm5/test';



# Gather User Input
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
print "Domain:\n";
my $input_domain = <STDIN>;



chomp(
		$input_ftp_host,
		$input_ftp_user,
		$input_ftp_pass,
		$input_dev_key,
		$input_dev_pass,
		$input_domain
	);

xml_upload(
		$input_ftp_host,
		$input_ftp_user, 
		$input_ftp_pass,
		$destination_directory,
		$pre_provide_file_location
	);

password_creation(
		$input_domain
	);





#TODO:
	# handle merchant2 vs mm5
	# user input converted to userConfig.xml
	# create account for all sub-domains
