# 701497
use strict;
use warnings;

use XML::Simple;
use Net::FTP;
use WWW::Mechanize;


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
	$mech->get('');
	$mech->submit_form(
		form_number => 0,
		fields => {
			'UserName' => '',
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

sub user_input{
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
	my $destination_directory = '/htdocs/mm5/test';

	chomp($input_ftp_host,$input_ftp_user,$input_ftp_pass,$input_dev_key,$input_dev_pass);
}


# xml_upload(
# 	$input_ftp_host,
# 	$input_ftp_user, 
# 	$input_ftp_pass,
# 	$destination_directory,
# 	$pre_provide_file_location
# );

password_creation();
# user_input();

# handle merchant2 vs mm5