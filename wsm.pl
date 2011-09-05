#!/usr/bin/perl
#Womz Storage Manager by Eric Wamsley
##############################LICENSE################################
#Copyright (c) 2011 Eric Wamsley.                                   #
#All rights reserved.                                               #
#                                                                   #
#Redistribution and use in source and binary forms are permitted    #
#provided that the above copyright notice and this paragraph are    #
#duplicated and viewable in all forms and that any documentation,   #
#advertising materials, and other materials related to such         #
#distribution and use acknowledge that the software was developed   #
#by ERIC WAMSLEY. THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT     # 
#ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION,  #
#THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A        #
#PARTICULAR PURPOSE.                                                #
##############################LICENSE################################


###########
#Variables#
###########
$g_vers = "2011.9.05 Experimental";
$g_app = "Womz Storage Manager";
$g_auth = "Eric Wamsley";
$g_site = "http://ewams.net";
$g_firstmsg = "This is an EXPERIMENTAL version of the software. Running it on any system is at YOUR OWN risk.";
$g_tempdir = "/tmp";

system("clear");

&printGreeting();
&testIsRoot();
&mainMenu();

&quit();



###########
#Functions#
###########


#Function mainMenu
#Prints the main menu of the program
#Params: n/a
#Returns: n/a
sub mainMenu {
	print "\n\nMain Menu\nWhat would you like to manage?\n";
	print "1 - Physical Storage Devices\n";
	print "2 - RAID devices\n";
	print "3 - Partitions\n";
	print "4 - FileSystems\n";
	print "5 - Install S.M.A.R.T. and RAID tools\n";
	print "6 - Exit\n";
	print "Enter a choice (or exit): ";
	chomp(my $option = <>);

    #determine user choice and execute that function
	if($option == 1){
		&menuStorageDevicesTop();
	}#end if
	elsif($option == 2){
		&mainMenu();
	}#end elsif
	elsif($option == 3){
		&mainMenu();
	}#end elsif
	elsif($option == 4){
		&mainMenu();
	}#end elsif
	elsif($option == 5){
		&installTools();
		&mainMenu();
	}#end elsif
	elsif(($option == 6) || ($option eq "exit")){
		&quit();
	}#end elsif
	else{
		print "\n\nPlease select an option from below.\n";
		&mainMenu();
	}#end else
}#end function mainMenu


#Function installTools
#Checks for smartctl and mdadm. If not installed installs them.
#Params: n/a
#Returns: n/a
sub installTools {
    #see if smartctl is installed on the system. if it is do nothing, if not install it
	if(&testSmartctl() eq "true"){
		print "\nsmartctl was found on this system and will not be reinstalled.";
	}#end if
	else {
		print "\nsmartctl will now be installed.";
		print "Depending on your Internet connection this may take several minutes.\n";
		my @result = `apt-get -y install smartmontools 2>&1`;
   		foreach my $i (@result){
            print $i;
       	}#end foreach
	}#end else
    
    #see if mdadm is installed on the system. if it is do nothing, if not install it
	if(&testMdadm() eq "true"){
		print "\nmdadm was found on this system and will not be reinstalled.\n";
	}#end if
	else{
        print "\nmdadm will now be installed.\n";
        print "Depending on your Internet connection this may take several minutes.\n";
        my @result = `apt-get -y install mdadm 2>&1`;
        foreach my $i (@result){
            print $i;
        }#end foreach
    }#end else
}#end function installTools


#Function testSmartctl
#Checks if smartctl is installed.
#Params: n/a
#Returns:
#0 - boolean - true if smartctl is installed - false if smartctl is NOT installed
sub testSmartctl {
	my $result = `smartctl -v 2>&1 | awk '/Bruce Allen/ {++x} END {if (x == 1) print "pass"; else print "fail"}'`;
	if($result =~ m/pass/){
		return "true";
	}#end if
	else{
		return "false";
	}#end else
}#end function testSmartctl


#Function testMdadm
#Checks if mdadm is installed.
#Params: n/a
#Returns:
#0 - boolean - true if mdadm is installed - false if mdadm is NOT installed
sub testMdadm {
        my $result = `mdadm -V 2>&1 | awk '/v3/ {++x} END {if (x == 1) print "pass"; else print "fail"}'`;
        if($result =~ m/pass/){
            return "true";
        }#end if
        else{
            return "false";
        }#end else
}#end function testMdadm


#Function menuStorageDevicesTop
#Top menu for the Storage Devices Menu (option 1 from Main Menu).
#Calls functions based on user input.
#Params: n/a
#Returns: n/a
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
    
    #determine user's choice and execute related functions
	if($g_option == 1){
        &scanNewDevices();
        &menuStorageDevicesTop();
	}#end if
    elsif($g_option == 2){
    	&printAllDiskInfo();
    	&menuStorageDevicesTop();
    }#end elsif
    elsif($g_option == 3){
    	&viewStorageDeviceDetails();
    	&menuStorageDevicesTop();
    }#end elsif
    elsif($g_option == 4){
    	&testStorageDevice();
    	&menuStorageDevicesTop();
    }#end elsif
    elsif($g_option == 5){
    	&mainMenu();
    }#end elsif
    elsif(($g_option == 6) || ($g_option eq "exit")){
    	&quit();
    }#end elsif
    else{
        print "\n\nPlease select an option from below.\n"
        &menuStorageDevicesTop();
    }#end else
}#end function menuStorageDevicesTop


#Function scanNewDevices
#Rescans the machine's SCSI adapters for new storage devices.
#Menu level: menuStorageDevicesTop->Option 1
#Params: n/a
#Returns: n/a
sub scanNewDevices {
    #get list of all scsi ports and generate command to run them
	my $command = "ls /sys/class/scsi_host | awk \'{ print \"echo \\\"- - -\\\" > /sys/class/scsi_host/\"\$0\"/scan\" }\' > /tmp/hostscan";
	system($command);
	my $cmdfile = "/tmp/hostscan";
	open(CMDFH, $cmdfile);
	my @cmds = <CMDFH>;
	close(CMDFH);
	print "\n\nPerforming rescan for new storage devices.\n";
    #Rescan each port
	foreach $line (@cmds){
		chomp($line);
		system($line);
		print "Scan complete.\n";
	}#end foreach
	print "\nAll scans complete.\nIf you are using an HBA or RAID controller you may have to manually run your manufacture supplied rescan software.\n";
}#end scanNewDevices function


#Function printAllDiskInfo
#Prints high level summary of all storage devices
#Menu level: menuStorageDevicesTop->Option 2
#Params: n/a
#Returns: n/a
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
        $totalsize = $totalsize+$disksize;
		$disksize = &convertSize($disksize);
		print $diskname."\tSize: ".$disksize."\n";
        $diskcount++;
	}#end foreach
    $totalsize = &convertSize($totalsize);
	print "\n\nTotal number of disks found: $diskcount\nTotal size of storage found: $totalsize\n";

}#end function printAllDiskInfo


#Function viewStorageDeviceDetails
#Creates menu item (from &selectDevice()) of devices, lets user pick one, prints out details of device, and prints out details of partitions (from &viewPartitionInfo()).
#Menu level: menuStorageDevicesTop->Option 3
#Params: n/a
#Returns: n/a
sub viewStorageDeviceDetails {
	print "\n\nView storage device details.\nWhich device do you want to view?\n";
	
    #get device selection from user
	my $device = &selectDevice();
	chomp($device);
	if($device eq "fail"){
		print "\n\nInvalid device selected.\n";
	}#end if
	else{
        #create tmp files for smartctl, fdisk, and blkid
		`smartctl -a $device 2>&1 > /tmp/smart`;
		`fdisk -luc $device 2>&1 | awk '\$0 ~ /sd/ && \$0 !~ /Disk/ { print \$0 }' > /tmp/fdisk`;
		`blkid 2>&1 > /tmp/blkid`;
        #get details about device
		chomp(my $size = `fdisk -l $device 2>&1 | awk '\$0 ~ /bytes/ && \$0 ~ /Disk/ {print \$5}'`);
		chomp(my $sectorsize = `fdisk -luc $device 2>&1 | awk '\$0 ~ /Sector size/ { print \$4 }'`);
		$size = &convertSize($size);	
		my @partitions = `cat /tmp/fdisk | awk '{ print \$1 }'`;

        #print information
		print "\n\nStorage device: $device\n";
		print "Sector Size: $sectorsize bytes\n";
		print "Device Capacity: $size\n";
        
        #test if smartctl exists, if does get more stats from it
        if(&testSmartctl() eq "true"){
            chomp(my $model = `cat /tmp/smart | awk '\$0 ~ /Model/ { print \$0 }'`);
    		chomp(my $serial = `cat /tmp/smart | awk '\$0 ~ /Serial/ { print \$0 }'`);
    		chomp(my $turnedon = `cat /tmp/smart | awk '\$0 ~ /Start_Stop_Count/ { print \$10 }'`);
    		chomp(my $poweredon = `cat /tmp/smart | awk '\$0 ~ /Power_On_Hours/ { print \$10 }'`);
            chomp(my $temp = `cat /tmp/smart | awk '\$0 ~ /Temperature_Celsius/ { print \$10 }'`);
    		chomp(my $rawreaderror = `cat /tmp/smart | awk '\$0 ~ /Raw_Read_Error_Rate/ { print \$10 }'`);
    		chomp(my $reallocsector = `cat /tmp/smart | awk '\$0 ~ /Reallocated_Sector_Ct/ { print \$10 }'`);
    		chomp(my $seekerror = `cat /tmp/smart | awk '\$0 ~ /Seek_Error_Rate/ { print \$10 }'`);
    		chomp(my $offuncor = `cat /tmp/smart | awk '\$0 ~ /Offline_Uncorrectable/ { print \$10 }'`);
            print "Model: $model\n";
            print "Serial Number: $serial\n";
    		print "\n\n";
    		print "Device Status:\n";
    		print "Current Temperature: $temp Celcius\n";
    		print "Total hours powered on: $poweredon\n";
    		print "Number of times powered on: $turnedon\n";
    		print "Total read errors from disk surface (Raw_Read_Error_Rate): $rawreaderror\n";
    		print "Total seek errors of heads (Seek_Error_Rate): $seekerror\n";
    		print "Total I/O uncorrectable errors from disk surface (Offline_Uncorrectable): $offuncor\n";
    		print "Total number of reallocated sectors from I/O error (Reallocated_Sector_Count): $reallocsector\n";
        }#end if
        else{
            print "\n\nS.M.A.R.T. tools not found. It is recommended that you run the tools installer from the main menu.";
        }#end else

		print "\n\n";
		print "Partition information:\n";
		
		my $totalparts = 0;
        #print partition information
		foreach $part (@partitions){
			chomp($part);
			&viewPartitionInfo($device, $part);
			$totalparts++;
		}#end foreach
		if($totalparts == 0){
			print "No partitions found on device.\n";
		}#end if
		else{
			print "Total partitions: $totalparts\n";
		}#end else

	}#end else

}#end function viewStorageDeviceDetails


#Function viewPartitionInfo
#Prints a table of various information regarding a partition.
#Params:
#0 - String - Device name that partition is on
#1 - String - Partition name to get info about
#Returns: n/a
#TODO - test partition for no filesystem, no mounts, and no space used/free#
sub viewPartitionInfo {
    my($device) = $_[0];
	my($partition) = $_[1];
    #get just partition name without /dev/ on it
	my @split = split("/",$partition);    
	chomp(my $workingpart = $split[2]);
    #see if partition is bootable
	chomp(my $isbootable = `cat /tmp/fdisk | awk '/$workingpart/ && /\\*/ { ++x } END {if (x == 1) print "yes"; else print "no"}'`);
    #see if device is a swap partition
	chomp(my $isswap = `cat /tmp/fdisk | awk '/$workingpart/ && /swap/ { ++x } END {if (x ==1) print "yes"; else print "no"}'`);
    #see if it is an extended partition
	chomp(my $isextended = `cat /tmp/fdisk | awk '/$workingpart/ && /Extended/ { ++x } END {if (x ==1) print "yes"; else print "no"}'`);
    #get size of sectors from the device the partition is on
	chomp(my $sectorsize = `fdisk -luc $device | awk '\$0 ~ /Sector size/ { print \$4 }'`);
	my $sectorsend;
	my $sectorstart;
	if($isbootable =~ m/yes/){
		chomp($sectorsend = `cat /tmp/fdisk | awk '\$0 ~ /$workingpart/ { print \$4 }'`);
		chomp($sectorstart = `cat /tmp/fdisk | awk '\$0 ~ /$workingpart/ { print \$3 }'`);
        $isbootable = " is bootable";
	}#end if
	else{
		chomp($sectorsend = `cat /tmp/fdisk | awk '\$0 ~ /$workingpart/ { print \$3 }'`);
        chomp($sectorstart = `cat /tmp/fdisk | awk '\$0 ~ /$workingpart/ { print \$2 }'`);
        $isbootable = "";
	}#end else
	my $totalsectors = $sectorsend - $sectorstart;
	my $totalsize = ($totalsectors*$sectorsize);
	$totalsize = &convertSize($totalsize);
    #get UUID of partition
	chomp(my $uuid = `cat /tmp/blkid | awk '\$0 ~ /$workingpart/ { print \$2 }' | awk 'BEGIN { FS = "\\\"" }; { print \$2 }'`);
	if(length($uuid) < 12){
		$uuid = "None";
	}#end if
    #get filesystem type
	chomp(my $fstype = `cat /tmp/blkid | awk '\$0 ~ /$workingpart/ { print \$3 }' | awk 'BEGIN { FS = "\\\"" }; { print \$2 }'`);
    if(length($fstype) < 1){
        $fstype = " and has no filesystem";
    }#end if
    else{
        $fstype = "and has a filesystem type of $fstype";
    }#end else
    #get mount location
	chomp(my $mountloc = `cat /etc/fstab | awk '\$0 ~ /$uuid/ { print \$2 }'`);
    if(length($mountloc) < 1){
        $mountloc = " and no mount location";
    }#end if
    else{
        $mountloc = " and mounted on $mountloc";
    }#end else
    #print results of all data found
	if($isextended =~ m/yes/){
		print "Partition found: $partition is an Extended partition \t\t\t\tSize is $totalsize\n";
	}#end if
	elsif($isswap =~ m/yes/){
		print "Partition found: $partition is System swap \t\t\t\t\tSize is $totalsize\n";
	}#end elsif
	else{
	   #get free space percentage
		chomp(my $free = `df -h $mountloc 2>&1 | awk '\$0 ~ /$workingpart/ { print 100-\$5 }'`);
        if(length($free) > 0){
            $free = " with $free\% free"
        }#end if
        else{
            $free = "";
        }#end else
		print "Partition found: $partition$isbootable$fstype$mountloc \tSize is $totalsize$free\n";
	}#end else

}#end function viewPartitionInfo



#Function testStorageDevice
#Uses smartmontools to test storage device functionality.
#Params:
#0 - String - Device name (eg /dev/sda)
#Returns: n/a
#TODO - write this functiona#
sub testStorageDevice {
	print "\n\nThis feature is not currently implemented in this version.\n";
}#end function testStorageDevice









            ####################
            ##COMMON FUNCTIONS##
            ####################
#All common functions are called from other functions#


#Function printGreeting
#Prints the first greeting message to screen
#Params: n/a
#Returns: n/a
sub printGreeting{
	print "Running $g_app version $g_vers by $g_auth.\n";
	print "Visit $g_site for more information.\n";
	print "\n$g_firstmsg\n";
}#end function printGreeting


#Function testIsRoot
#Tests to see if the script is ran as root. If not it quickly exits.
#Params: n/a
#Returns: n/a
sub testIsRoot {
	if( $< != 0 ){
		&quit("This application must be ran as root.");
	}#end if
}#end function testIsRoot


#Function getDisks
#Gets a listing of all storage devices and puts in /tmp/disks
#Params: n/a
#Returns: n/a
sub getDisks {
	my $command = "awk \'\$3 ~ /[hs]d/ && \$3 !~ /[0-9]/ {print \"/dev/\" \$3}\' /proc/diskstats | sort > /tmp/disks";
	system($command);
}#end function getDisks


#Function quit
#Exits the program.
#Params:
#0 - String - Reason for exit
#Returns: n/a
#TODO - remove all temporary files#
sub quit {
	my($reason) = @_;
	die $reason."\nHave a nice day.\n";
}#end quit function


#Function convertSize
#Tests the provided number if it is KB, MB, GB, or TB and returns with ###.## _B
#Params:
#0 - Integer - Total size in Bytes
#Returns:
#0 - String - New value with unit (eq: 349 MegaBytes)
sub convertSize{
	my($size) = @_;
	chomp($size);
	if($size < 1024){
		return "$size Bytes";
	}#end if
	elsif(($size >= 1024) && ($size < 1048576)){
		$size = ($size/1024);
		$size = sprintf("%.2f", $size);
		return "$size KiloBytes";
	}#end elsif
	elsif(($size >= 1048576) && ($size < 1073741824)){
		$size = ($size/1048576);
		$size = sprintf("%.2f", $size);
		return "$size MegaBytes";
	}#end elsif
	elsif(($size >= 1073741824) && ($size < 1099511627776)){
		$size = ($size/1073741824);
		$size = sprintf("%.2f", $size);
		return "$size GigaBytes";
	}#end elsif
	else{
		$size = ($size/1099511627776);
		$size = sprintf("%.2f", $size);
		return "$size TeraBytes";
	}#end else
}#end function convertSize


#Function selectDevice
#Prints a menu of all physical devices and allows the user to select one.
#Params: n/a
#Returns:
#0 - String - Full path to device (eg: /dev/sda) or "fail" if user enters invalid option
sub selectDevice {
    #create list of disks in tmp file
	&getDisks();
    my $disksfile = "/tmp/disks";
    my $counter = 1;
	my $diskchoice = 0;
    open(DISKSFH, $disksfile);
    my @disks = <DISKSFH>;
    close(DISKSFH);
    
    #print menu with each device
    foreach $line (@disks){
        my $diskname = $line;
        chomp($diskname);
        print "$counter - $diskname\n";
        $counter++;
    }#end foreach
	$counter--;
    
    #get user input
    print "\nEnter a device number: ";
    chomp($diskchoice = <>);
	if (($diskchoice == $counter) || (($diskchoice <= $counter) && ($diskchoice > 0))){
		$diskchoice = $diskchoice-1;
		return $disks[$diskchoice];
	}#end if
	else{
		return "fail";
	}#end else
}#end function selectDevice

#####
#EOF#
#####