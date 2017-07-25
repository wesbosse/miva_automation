# 701497
use strict;
use warnings;

use XML::Simple;
# use Data::Dumper;
# use Net::FTPSSL;
use WWW::Mechanize;
use Browser::Open qw(open_browser);
use Term::ReadKey;
use Crypt::PBKDF2;
use LWP::Protocol::https;

sub pre_provide_manipulation {
	#initialize hashing algo
	# my $pbkdf2 = Crypt::PBKDF2->new(
	# 	hash_class => 'SHA1',
	# 	iterations => 1000,
	# 	output_len => 20,
	# 	salt_len => 4,
	# );

	# #set temporary password
	# my $hash = $pbkdf2->generate('M1v@temp');

	# create object
	my $xml = new XML::Simple;

	# read XML file
	my $pre_provide = $xml->XMLin('pre-provide.xml');

	# insert temporary password


	# # print output
	print Dumper($pre_provide);
	print "\n"; 
	# print $hash; 
} 

sub xml_upload {
	# grab user input and initialize FTP instance
	my ($host, $user, $pass, $fpath, $sub) = @_;
	my $ftp = Net::FTPSSL->new($host, Debug => 0);
	my $dir = '';
	# if ($sub ne 'www') {
	# 	my $dir = '/private/'.$sub.'/mivadata/';
	# } else {
	my $dir = '/private/mivadata/';
	# }

	# login, navigate to private, and upload pre-provide
	$ftp->login($user, $pass) || die $ftp->message;
	$ftp->cwd($dir);
	$ftp->put($fpath) || die $ftp->message;
	$ftp->quit;

	 print $ftp->message;
}

sub password_creation {
	my ($key, $pass, $sub, $domain) = @_;
 	my $mech = WWW::Mechanize->new;  
 	# print $sub;
 	# print $domain;
	$mech->get('https://'.$sub.'.'.$domain.'.com/mm5/admin.mvc');
	$mech->submit_form(
		form_number => 0,
		fields => {
			'UserName' => 'support_wbosse',
			'PassWord' => '6lupqPBvjDVh2MFr',
		},
	);
	$mech->submit_form(
		form_number => 0,
		fields => {
			'User_License' => $key,
			'User_Password' => $pass,
			'User_VerifyPassword' => $pass
		},
	);
	$mech->tick('name' => 'User_Accept_License');
	$mech->submit_form(
		form_number => 0,
		fields => {
		},
	);

	print $mech->content;
}

sub ftp_account_creation {
	my $mech = WWW::Mechanize->new;  
	
	print "My.Miva Username:\n"
	my $my_miva_username = chomp(<STDIN>);

	ReadMode('noecho');
		print "My.Miva Password:\n"
		my $my_miva_pass = chomp(<STDIN>);

		print "Two Factor Auth:\n"
		my $two_factor = chomp(<STDIN>);
	ReadMode(0);

	$mech->get('https://my.miva.com');
	$mech->submit_form(
		form_number => 0,
		fields => {
			'login' => $my_miva_username,
			'PassWord' => $my_miva_pass,
		},
	);

	$mech->submit_form(
		form_number => 0,
		fields => {
			'two_factor' => $two_factor,
		},
	);

	print $mech->content;
}

# Testing Variables
# my $pre_provide_file_location = 'pre-provide.xml';
my $pre_provide_file_location = 'pre-provide.xml';


# Gather User Input
print "FTP Host:\n";
my $input_ftp_host = <STDIN>;
print "FTP Username:\n";
my $input_ftp_user = <STDIN>;
print "FTP Password:\n";
ReadMode('noecho');
my $input_ftp_pass = <STDIN>;
print "Dev Key:\n";
my $input_dev_key = <STDIN>;
print "Desired Dev Account Password:\n";
ReadMode(0);
my $input_dev_pass = <STDIN>;
print "Sub-Domain:\n";
my $input_sub_domain = <STDIN>;
print "Domain:\n";
my $input_domain = <STDIN>;

chomp(
		$input_ftp_host,
		$input_ftp_user,
		$input_ftp_pass,
		$input_dev_key,
		$input_dev_pass,
		$input_sub_domain,
		$input_domain
	);

# pre_provide_manipulation();

xml_upload(
		$input_ftp_host,
		$input_ftp_user, 
		$input_ftp_pass,
		$pre_provide_file_location,
		$input_sub_domain
	);
print "\n \n \n";
password_creation(
		$input_dev_key,
		$input_dev_pass,
		$input_sub_domain,
		$input_domain
	);

open_browser('http://'.$input_sub_domain.'.'.$input_domain.'.com/mm5/admin.mvc');

ftp_account_creation();
#TODO:
	# handle merchant2 vs mm5
	# user input converted to userConfig.xml
	# create account for all sub-domains
	# LastPass CLI integration
	# auto log-in


#SECURITY 
	#rate limiter
	#restricted by my miva account
	#Sanatize inputs
	
