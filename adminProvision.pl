# 701497
use strict;
use warnings;

use XML::Simple;
use Net::FTPSSL;
use WWW::Mechanize;
use Browser::Open qw(open_browser);
use Term::ReadKey;

use LWP::Protocol::https;


sub xml_upload {

	print "FTP Host:\n";
		my $host = <STDIN>;
	print "FTP Username:\n";
		my $user = <STDIN>;
	print "FTP Password:\n";
		ReadMode('noecho');
		my $pass = <STDIN>;
		ReadMode(0);
	
	# Generate for all sub domains - TODO
	print "Sub-Domain:\n";
		my $sub = <STDIN>;
	#####################################
	
	my $fpath = 'pre-provide.xml';

	if ($sub ne 'www') {
		my $dir = '/private/'.$sub.'/mivadata/';
	} else {
		my $dir = '/private/mivadata/';
	}

	# connect to FTP host
	my $ftp = Net::FTPSSL->new($host, Debug => 0);
	
	# login, navigate to proper directory, and upload pre-provide
	$ftp->login($user, $pass) || die $ftp->message;
	$ftp->cwd($dir);
	$ftp->put($fpath) || die $ftp->message;
	$ftp->quit;

	#print $ftp->message;
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



# Gather User Input

print "Dev Key:\n";
my $input_dev_key = <STDIN>;
print "Desired Dev Account Password:\n";
ReadMode(0);
my $input_dev_pass = <STDIN>;


chomp(
		$input_ftp_host,
		$input_ftp_user,
		$input_ftp_pass,
		$input_dev_key,
		$input_dev_pass,
		$input_sub_domain,
		$input_domain
	);


xml_upload(
		$input_ftp_host,
		$input_ftp_user, 
		$input_ftp_pass,
		$pre_provide_file_location,
		$input_sub_domain
	);

password_creation(
		$input_dev_key,
		$input_dev_pass,
		$input_sub_domain,
		$input_domain
	);

open_browser(
		'http://'.$input_sub_domain.'.'.$input_domain.'.com/mm5/admin.mvc'
	);

ftp_account_creation();



	
