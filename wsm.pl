#!/usr/bin/perl
#Drive Manager by Eric Wamsley

###########
#Variables#
###########
$g_vers = "2011.9.01 Experimental";
$g_app = "Drive Manager";
$g_auth = "Eric Wamsley";
$g_site = "http://ewams.net";
$g_firstmsg = "This is an EXPERIMENTAL version of the software. Running it on any system is at YOUR OWN risk.";
$g_option;
$g_tempdir = "/tmp";

system("clear");

&printGreeting();
&testIsRoot();
&mainMenu();






&quit();
###########
#Functions#
###########

sub printGreeting{
	print "Running $g_app version $g_vers by $g_auth.\n";
	print "Visit $g_site for more information.\n";
	print "\n$g_firstmsg\n";
}#end printGreeting function


sub testIsRoot {
	if( $< != 0 ){
		die "This application must be ran as root.\n";
	}#end if
}#end testIsRoot function



sub getDisks {
	my $command = "awk \'\$3 ~ /[hs]d/ && \$3 !~ /[0-9]/ {print \"/dev/\" \$3}\' /proc/diskstats | sort > /tmp/disks";
	system($command);
}


sub printAllDiskInfo {

	&getDisks();
	my $disksfile = "/tmp/disks";
	open(DISKSFH, $disksfile);
	my @disks = <DISKSFH>;
	close(DISKSFH);
	my $diskcount = 0;
	my $totalsize = 0;
	print "\n\nStorage found on this system:\n";
	foreach $line (@disks){
		my $diskname = $line;
		chomp($diskname);
		my $disksize = `fdisk -l $diskname 2>&1 | awk '\$0 ~ /bytes/ && \$0 ~ /Disk/ {print \$5}'`;
		$disksize = $disksize/1073741824;
		print $diskname."\tSize: ".$disksize."GB\n";
		$diskcount++;
		$totalsize = $totalsize+$disksize;
	}#end foreach

	print "\n\nTotal number of disks found: $diskcount\nTotal size of storage found: $totalsize GB\n";

}
sub mainMenu {
	#system("clear");
	print "\n\nMain Menu\nWhat would you like to manage?\n";
	print "1 - Physical Storage Devices\n";
	print "2 - RAID devices\n";
	print "3 - Partitions\n";
	print "4 - FileSystems\n";
	print "5 - Install S.M.A.R.T. and RAID tools\n";
	print "6 - Exit\n";
	print "Enter a choice (or exit): ";
	chomp($g_option = <>);

	if($g_option == 1){
		&menuStorageDevicesTop();
	}
	elsif($g_option == 2){
		&mainMenu();
	}
	elsif($g_option == 3){
		&mainMenu();
	}
	elsif($g_option == 4){
		&mainMenu();
	}
	elsif($g_option == 5){
		&installTools();
		&mainMenu();
	}
	elsif($g_option == 6){
		&quit();
	}
	elsif($g_option eq "exit"){
		&quit();
	}
	else{
		print "\n\nPlease select an option from below.\n";
		&mainMenu();
	}
}#end mainMenu sub

sub testSmartctl {
	my $result = `smartctl -v 2>&1 | awk '/Bruce Allen/ {++x} END {if (x == 1) print "pass"; else print "fail"}'`;
	if($result =~ m/pass/){
		return "true";
	}
	else{
		return "false";
	}
}



sub testMdadm {
        my $result = `mdadm -V 2>&1 | awk '/v3/ {++x} END {if (x == 1) print "pass"; else print "fail"}'`;
        if($result =~ m/pass/){
                return "true";
        }
        else{
                return "false";
        }
}



sub installTools {
	if(&testSmartctl() eq "true"){
		print "\nsmartctl was found on this system and will not be reinstalled.";
	}
	else {
		print "\nsmartctl will now be installed.";
		print "Depending on your Internet connection this may take several minutes.\n";
		my @result = `apt-get -y install smartmontools 2>&1`;
       		foreach my $i (@result){
       	       		print $i;
	       	}
	}
	if(&testMdadm() eq "true"){
		print "\nmdadm was found on this system and will not be reinstalled.\n";
	}
	else{
                print "\nmdadm will now be installed.\n";
                print "Depending on your Internet connection this may take several minutes.\n";
                my @result = `apt-get -y install mdadm 2>&1`;
                foreach my $i (@result){
                        print $i;
                }
        }

	
}

sub menuStorageDevicesTop {
	print "\n\nPhysical Storage Devices\nWhat would you like to do?\n";
	print "1 - Scan for new storage devices\n";
	print "2 - View all storage devices\n";
	print "3 - View storage device details\n";
	print "4 - Test storage device\n";
	print "5 - Main Menu\n";
	print "6 - Exit\n";
	print "Enter a choice (or exit): ";
	chomp($g_option = <>);
	if($g_option == 1){
        	&scanNewDevices();
		&menuStorageDevicesTop();
	}
        elsif($g_option == 2){
		&printAllDiskInfo();
		&menuStorageDevicesTop();
        }
        elsif($g_option == 3){
		&viewStorageDeviceDetails();
		&menuStorageDevicesTop();
        }
        elsif($g_option == 4){
		&testStorageDevice();
		&menuStorageDevicesTop();
        }
        elsif($g_option == 5){
		&mainMenu();
        }
        elsif($g_option == 6){
		&quit();
        }
        elsif($g_option eq "exit"){
		&quit();
        }
        else{
            print "\n\nPlease select an option from below.\n"
            &menuStorageDevicesTop();
        }
}#end menuStorageDevicesTop function

sub scanNewDevices {
	my $command = "ls /sys/class/scsi_host | awk \'{ print \"echo \\\"- - -\\\" > /sys/class/scsi_host/\"\$0\"/scan\" }\' > /tmp/hostscan";
	system($command);
	my $cmdfile = "/tmp/hostscan";
	open(CMDFH, $cmdfile);
	my @cmds = <CMDFH>;
	close(CMDFH);
	print "\n\nPerforming rescan for new storage devices.\n";
	foreach $line (@cmds){
		chomp($line);
		system($line);
		print "Scan complete.\n";
	}
	print "\nAll scans complete.\nIf you are using an HBA you may have to manually run your manufacture supplied rescan software.\n";
}#end scanNewDevices function

sub testStorageDevice {
	print "\n\nThis feature is not currently implemented in this version.\n";
}#end function testStorageDevice




sub viewStorageDeviceDetails {
	print "\n\nView storage device details.\nWhich device do you want to view?\n";
	
	my $device = &selectDevice();
	chomp($device);
	if($device eq "fail"){
		print "\n\nInvalid device selected.\n";
	}
	else{
		`smartctl -a $device 2>&1 > /tmp/smart`;
		`fdisk -luc $device 2>&1 | awk '\$0 ~ /sd/ && \$0 !~ /Disk/ { print \$0 }' > /tmp/fdisk`;
		`blkid 2>&1 > /tmp/blkid`;
		chomp(my $model = `cat /tmp/smart | awk '\$0 ~ /Model/ { print \$0 }'`);
		chomp(my $serial = `cat /tmp/smart | awk '\$0 ~ /Serial/ { print \$0 }'`);
		chomp(my $turnedon = `cat /tmp/smart | awk '\$0 ~ /Start_Stop_Count/ { print \$10 }'`);
		chomp(my $poweredon = `cat /tmp/smart | awk '\$0 ~ /Power_On_Hours/ { print \$10 }'`);
		chomp(my $temp = `cat /tmp/smart | awk '\$0 ~ /Temperature_Celsius/ { print \$10 }'`);
		chomp(my $rawreaderror = `cat /tmp/smart | awk '\$0 ~ /Raw_Read_Error_Rate/ { print \$10 }'`);
		chomp(my $reallocsector = `cat /tmp/smart | awk '\$0 ~ /Reallocated_Sector_Ct/ { print \$10 }'`);
		chomp(my $seekerror = `cat /tmp/smart | awk '\$0 ~ /Seek_Error_Rate/ { print \$10 }'`);
		chomp(my $offuncor = `cat /tmp/smart | awk '\$0 ~ /Offline_Uncorrectable/ { print \$10 }'`);
		chomp(my $size = `fdisk -l $device 2>&1 | awk '\$0 ~ /bytes/ && \$0 ~ /Disk/ {print \$5}'`);
		chomp(my $sectorsize = `fdisk -luc /dev/sdd | awk '\$0 ~ /Sector size/ { print \$4 }'`);
		$size = $size/1073741824;	
		my @partitions = `cat /tmp/fdisk | awk '{ print \$1 }'`;


		print "\n\nStorage device: $device\n";
		print "Model: $model\n";
		print "Serial Number: $serial\n";
		print "Sector Size: $sectorsize bytes\n";
		print "Device Capacity: $size Gigabytes\n";
		print "\n\n";
		print "Device Status:\n";
		print "Current Temperature: $temp Celcius\n";
		print "Total hours powered on: $poweredon\n";
		print "Number of times powered on: $turnedon\n";
		print "Total read errors from disk surface (Raw_Read_Error_Rate): $rawreaderror\n";
		print "Total seek errors of heads (Seek_Error_Rate): $seekerror\n";
		print "Total I/O uncorrectable errors from disk surface (Offline_Uncorrectable): $offuncor\n";
		print "Total number of reallocated sectors from I/O error (Reallocated_Sector_Count): $reallocsector\n";
		print "\n\n";
		print "Partition information:\n";
		
		my $totalparts = 0;
		foreach $part (@partitions){
			chomp($part);
			&viewPartitionInfo($part);
			$totalparts++;
		}
		if($totalparts == 0){
			print "No partitions found on device.\n";
		}
		else{
			print "Total partitions: $totalparts\n";
		}


	}
	

}#end function viewStorageDeviceDetails


sub viewPartitionInfo {
	my($partition) = @_;
	my @split = split("/",$partition);
	chomp(my $workingpart = $split[2]);
	chomp(my $isbootable = `cat /tmp/fdisk | awk '/$workingpart/ && /\\*/ { ++x } END {if (x == 1) print "yes"; else print "no"}'`);
	chomp(my $isswap = `cat /tmp/fdisk | awk '/$workingpart/ && /swap/ { ++x } END {if (x ==1) print "yes"; else print "no"}'`);
	chomp(my $isextended = `cat /tmp/fdisk | awk '/$workingpart/ && /Extended/ { ++x } END {if (x ==1) print "yes"; else print "no"}'`);
	chomp(my $sectorsize = `fdisk -luc /dev/sdd | awk '\$0 ~ /Sector size/ { print \$4 }'`);
	my $sectorsend;
	my $sectorstart;
	if($isbootable =~ m/yes/){
		chomp($sectorsend = `cat /tmp/fdisk | awk '\$0 ~ /$workingpart/ { print \$4 }'`);
		chomp($sectorstart = `cat /tmp/fdisk | awk '\$0 ~ /$workingpart/ { print \$3 }'`);
	}
	else{
		chomp($sectorsend = `cat /tmp/fdisk | awk '\$0 ~ /$workingpart/ { print \$3 }'`);
                chomp($sectorstart = `cat /tmp/fdisk | awk '\$0 ~ /$workingpart/ { print \$2 }'`);
	}
	my $totalsectors = $sectorsend - $sectorstart;
	my $totalsize = ($totalsectors*$sectorsize);
	$totalsize = &convertSize($totalsize);

	chomp(my $uuid = `cat /tmp/blkid | awk '\$0 ~ /$workingpart/ { print \$2 }' | awk 'BEGIN { FS = "\\\"" }; { print \$2 }'`);
	if(length($uuid) < 12){
		$uuid = "None";
	}
	chomp(my $fstype = `cat /tmp/blkid | awk '\$0 ~ /$workingpart/ { print \$3 }' | awk 'BEGIN { FS = "\\\"" }; { print \$2 }'`);
	chomp(my $mountloc = `cat /etc/fstab | awk '\$0 ~ /$uuid/ { print \$2 }'`);
	if($isbootable =~ m/yes/){
                $isbootable = "is bootable";
        }
        else{
                $isbootable = "";
        }


	if($isextended =~ m/yes/){
		print "Partition found: $partition is an Extended partition \t\t\t\tSize is $totalsize\n";
	}
	elsif($isswap =~ m/yes/){
		print "Partition found: $partition is System swap \t\t\t\t\tSize is $totalsize\n";
	}
	else{
		chomp(my $free = `df -h $mountloc 2>&1 | awk '\$0 ~ /$workingpart/ { print 100-\$5 }'`);
		print "Partition found: $partition $isbootable and has a filesystem type of $fstype mounted on $mountloc \tSize is $totalsize with $free \% free\n";
	}

}#end function viewPartitionInfo


#Function convertSize
#Tests the provided number if it is KB, MB, GB, or TB and returns with ### XB
#Expecting a number in BYTES
sub convertSize{
	my($size) = @_;
	chomp($size);
	if($size < 1024){
		return "$size Bytes";
	}
	elsif(($size >= 1024) && ($size < 1048576)){
		$size = ($size/1024);
		$size = sprintf("%.2f", $size);
		return "$size KiloBytes";
	}
	elsif(($size >= 1048576) && ($size < 1073741824)){
		$size = ($size/1048576);
		$size = sprintf("%.2f", $size);
		return "$size MegaBytes";
	}
	elsif(($size >= 1073741824) && ($size < 1099511627776)){
		$size = ($size/1073741824);
		$size = sprintf("%.2f", $size);
		return "$size GigaBytes";
	}
	else{
		$size = ($size/1099511627776);
		$size = sprintf("%.2f", $size);
		return "$size TeraBytes";
	}
}#end function convertSize

sub selectDevice {
	&getDisks();
        my $disksfile = "/tmp/disks";
        my $counter = 1;
	my $diskchoice = 0;
        open(DISKSFH, $disksfile);
        my @disks = <DISKSFH>;
        close(DISKSFH);
        foreach $line (@disks){
                my $diskname = $line;
                chomp($diskname);
                print "$counter - $diskname\n";
                $counter++;
        }
	$counter--;
        print "\nEnter a device number: ";
        chomp($diskchoice = <>);
	if (($diskchoice == $counter) || (($diskchoice <= $counter) && ($diskchoice > 0))){
		$diskchoice = $diskchoice-1;
		return $disks[$diskchoice];
	}
	else{
		return "fail";
	}
}#end function selectDevice


sub quit {
	my($reason) = @_;
	die $reason."\nHave a nice day.\n";
}#end quit function

