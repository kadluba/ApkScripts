#!/usr/bin/perl

# 
# Usage: perl apkapi.pl <apk-file>
# 
# Extracts the apk and decompiles (baksmali) the program from a given APK. Then searches for calls of "dangerous" APIs in the decompiled source.
# 
# Christian Kadluba, 2012, christian.kadluba@gmail.com
# 

use strict;
use warnings;

use Cwd;
use File::Basename;
use File::Find;


sub extractApk
{
	my $file = shift;
	my $dir = shift;

	my $ret = system("./apktool", "d", "-f", $file, $dir);
	if (($ret >>=8) != 0) {
		print "Failed to run ./apktool\n";
		return 0;
	}

	return 1;
}



sub searchApis
{
	use constant APIS => (
		# https://developer.android.com/reference/packages.html
		"android/location/LocationManager", 
		"android/location/LocationListener",
		"android/telephony/SmsManager",
		"andoid/provider/ContactsContract",
		"andoid/provider/Contacts",
		"android/bluetooth",
		"android/content/SharedPreferences",
		"android/preference",
		"android/net/wifi",
		"android/os/storage",
		"android/providers/CalendarContract",
		"android/telephony",
		"android/content/pm/PackageManager/getInstalledPackages",
		"android/content/pm/PackageManager/getInstalledApplications"
		# ... and many more
	);
	my $dir = shift;

	foreach (&APIS) {
		my $api = $_;
		if (open FILE, "grep -rl \"" . $api . "\" " . $dir . "/smali/* | ") {
			my $headerPrinted = 0;
			while (<FILE>) {
				if ($headerPrinted == 0) {
					print "WARNING: API " . $api . " found in the following files\n";
					$headerPrinted = 1;
				}
				print "\t" . $_;
			}
			close FILE;
		}
	}

	return 1;
}


# Begin of main script
$#ARGV == 0 or die "Usage: apkapi.pl <apk-file>\n";

my $fileName = $ARGV[0];
my $dirName = basename($fileName, ".apk");

print "APK API Call Search Tool 1.0, scanning " . $fileName . "\n";

extractApk($fileName, $dirName)
	or die "Could not extract APK\n";

searchApis($dirName)
	or die "Could not search API calls in dir " . $dirName . "\n";

exit 0;

