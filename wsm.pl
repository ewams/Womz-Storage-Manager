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
use strict;        
my $g_vers = "2011.9.21 Experimental";
my $g_app = "Womz Storage Manager";
my $g_auth = "Eric Wamsley";
my $g_site = "http://ewams.net";
my $g_firstmsg = "This is an EXPERIMENTAL version of the software. Running it on any system is at YOUR OWN risk.";
my $g_warning = "Using this program is at *your own* risk. If you are unsure of its purpose type EXIT immediatly.\nThe author will not be held liable for any loss or damage to any data, system, time, or mental health from using this software.\nBy using this software you agree to this warning message.";
my $g_tempdir = "/tmp";

system("clear");

&printGreeting();
&testIsRoot();
&mainMenu();

&quit();



        ################
        #Menu Functions#
        ################


#Function mainMenu
#Prints the main menu of the program
#Params: n/a
#Returns: n/a
sub mainMenu {
	print "\n\nMain Menu\nWhat would you like to manage?\n";
	print "1 - Physical Storage Devices\n";
	print "2 - RAID Devices\n";
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
        print "\nTODO\n";
		&mainMenu();
	}#end elsif
	elsif($option == 3){
		&menuPartitionsTop();
	}#end elsif
	elsif($option == 4){
        &menuFilesystemsTop();
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
	chomp(my $option = <>);
    
    #determine user's choice and execute related functions
	if($option == 1){
        &scanNewDevices();
        &menuStorageDevicesTop();
	}#end if
    elsif($option == 2){
    	&printAllDiskInfo();
    	&menuStorageDevicesTop();
    }#end elsif
    elsif($option == 3){
    	&viewStorageDeviceDetails();
    	&menuStorageDevicesTop();
    }#end elsif
    elsif($option == 4){
    	&testStorageDevice();
    	&menuStorageDevicesTop();
    }#end elsif
    elsif($option == 5){
    	&mainMenu();
    }#end elsif
    elsif(($option == 6) || ($option eq "exit")){
    	&quit();
    }#end elsif
    else{
        print "\n\nPlease select an option from below.\n"
        &menuStorageDevicesTop();
    }#end else
}#end function menuStorageDevicesTop


#Function menuPartitionsTop
#Top menu or the partitions menu (option 3 from Main Menu).
#Calls functions based on user input.
#Params: n/a
#Returns: n/a
sub menuPartitionsTop {
    print "\n\nPartitions\nWhat would you like to do?\n";
    print "1 - View all partitions\n";
    print "2 - Create a partition\n";
    print "3 - Delete a partition\n";
    print "4 - Main Menu\n";
    print "5 - Exit\n";
    print "Enter a choice (or exit): ";
    chomp(my $option = <>);
    
    #determine user choice and run related function
    if($option == 1){
        &viewAllPartitions();
        &menuPartitionsTop();
    }#end if
    elsif($option == 2){
        &createNewPartition();
        &menuPartitionsTop();
    }#end elsif
    elsif($option == 3){
        &deletePartition();
        &menuPartitionsTop();
    }#end elsif
    elsif($option == 4){
        &mainMenu();
    }#end elsif
    elsif(($option == 5) || ($option eq "exit")){
    	&quit();
    }#end elsif
    else{
        print "\n\nPlease select an option from below.\n"
        &menuPartitionsTop();
    }#end else
}#end function menuPartitionsTop


#Function menuFilesystemsTop
#Top menu or the filesystems menu (option 4 from Main Menu).
#Calls functions based on user input.
#Params: n/a
#Returns: n/a
sub menuFilesystemsTop {
    print "\n\nFilesystems\nWhat would you like to do?\n";
    print "1 - Create a Filesystem\n";
    print "2 - Mount a Filesystem\n";
    print "3 - Unmount a Filesystem\n";
    print "4 - Main Menu\n";
    print "5 - Exit\n";
    print "Enter a choice (or exit): ";
    chomp(my $option = <>);
    
    #determine user choice and run related function
    if($option == 1){
        &createFilesystem();
        &menuFilesystemsTop();
    }#end if
    elsif($option == 2){
        &mountFileSystem();
        &menuFilesystemsTop();
    }#end elsif
    elsif($option == 3){
        &mainMenu();
    }#end elsif
    elsif($option == 4){
        &mainMenu();
    }#end elsif
    elsif(($option == 5) || ($option eq "exit")){
    	&quit();
    }#end elsif
    else{
        print "\n\nPlease select an option from below.\n"
        &menuFilesystemsTop();
    }#end else
}#end function menuFilesystemsTop







            ####################
            ##COMMON FUNCTIONS##
            ####################


#Function printGreeting
#Prints the first greeting message to screen
#Params: n/a
#Returns: n/a
sub printGreeting{
	print "\nRunning $g_app version $g_vers by $g_auth.\n";
	print "Visit $g_site for more information.\n";
	print "\n$g_firstmsg\n";
    print "\n$g_warning\n";
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
sub quit {
    `rm -rf /tmp/blkid /tmp/disks /tmp/fdisk /tmp/hostscan /tmp/smart /tmp/ofile`;
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
    foreach my $line (@disks){
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
	foreach my $line (@cmds){
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
	foreach my $line (@disks){
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
		foreach my $part (@partitions){
			chomp($part);
			&viewPartitionInfo($device, $part);
            print "\n";
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
sub viewPartitionInfo {
    my($device) = $_[0];
	my($partition) = $_[1];
    #get just partition name without /dev/ on it
	my @split = split("/",$partition);    
	chomp(my $workingpart = $split[2]);
    `fdisk -luc $device 2>&1 | awk '(\$0 ~ /sd/ || \$0 ~ /md/) && \$0 !~ /Disk/ { print \$0 }' > /tmp/fdisk`;
	`blkid 2>&1 > /tmp/blkid`;
    #see if partition is bootable
	chomp(my $isbootable = `cat /tmp/fdisk | awk '/$workingpart/ && /\\*/ { ++x } END {if (x == 1) print "yes"; else print "no"}'`);
    #see if device is a swap partition
	chomp(my $isswap = `cat /tmp/fdisk | awk '/$workingpart/ && /swap/ { ++x } END {if (x ==1) print "yes"; else print "no"}'`);
    #see if it is an extended partition
	chomp(my $isextended = `cat /tmp/fdisk | awk '/$workingpart/ && /Extended/ { ++x } END {if (x ==1) print "yes"; else print "no"}'`);
    #get size of sectors from the device the partition is on
	chomp(my $sectorsize = `fdisk -luc $device 2>&1 | awk '\$0 ~ /Sector size/ { print \$4 }'`);
	my $sectorsend;
	my $sectorstart;
	if($isbootable =~ m/yes/){
		chomp($sectorsend = `cat /tmp/fdisk | awk '\$0 ~ /$workingpart/ { print \$4 }'`);
		chomp($sectorstart = `cat /tmp/fdisk | awk '\$0 ~ /$workingpart/ { print \$3 }'`);
        $isbootable = " is bootable and";
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
	chomp(my $uuid = `cat /tmp/blkid | awk 'BEGIN { FS = " " } \$0 ~ /$workingpart:/ { print \$2 }' | awk 'BEGIN { FS = "\\\"" }; { print \$2 }'`);
	if(length($uuid) < 12){
		$uuid = "None";
	}#end if
    #get filesystem type, note: some fstypes have additional blkid info like uuid_sub and sec_type, etc.
    chomp(my $fstype = `cat /tmp/blkid |  awk 'BEGIN { FS=" TYPE=\\""} \$0 ~ /$workingpart/ {sub(/\\"/, "", \$2); print \$2}'`);
    if(length($fstype) < 1){
        $fstype = " has no filesystem ";
    }#end if
    else{
        $fstype = " has a filesystem type of $fstype";
    }#end else
    #get mount location
	chomp(my $mountloc = `cat /etc/fstab | awk '\$0 ~ /$uuid/ { print \$2 }'`);
    #print "\n\nrunning on $workingpart: cat /etc/fstab | awk '0 ~ /$uuid/ { print 2 }'\n\n";
    if(length($mountloc) < 1){
        $mountloc = "and no mount location";
    }#end if
    else{
        $mountloc = "mounted on $mountloc";
    }#end else
    #print results of all data found
	if($isextended =~ m/yes/){
		print "$partition is an Extended partition \t\t\t\tSize is $totalsize";
	}#end if
	elsif($isswap =~ m/yes/){
		print "$partition is System Swap \t\t\t\t\tSize is $totalsize";
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
		print "$partition$isbootable$fstype$mountloc \tSize is $totalsize$free";
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


#Function viewAllPartitions
#Prints all partitions on every device.
#Params: n/a
#Returns: n/a
sub viewAllPartitions {
    print "\n\nAll partitions found:\n";
    
    #create list of disks in tmp file
	&getDisks();
    my $disksfile = "/tmp/disks";
    open(DISKSFH, $disksfile);
    my @disks = <DISKSFH>;
    close(DISKSFH);

    #run through each device
    foreach my $line (@disks){ 
        chomp(my $devicename = $line);

        #get all partitions for device
        my @partitions = `fdisk -luc $devicename 2>&1 | awk '\$0 ~ /sd/ && \$0 !~ /Disk/ { print \$1 }'`;
        foreach my $part (@partitions){
			chomp($part);
			&viewPartitionInfo($devicename, $part);
            print "\n";
		}#end foreach
    }#end foreach	

}#end function viewAllPartitions


#Function createNewPartition
#Creates a new partition on a specified device.
#Params: n/a
#Returns: n/a
sub createNewPartition {
    print "\n\nCreate a new partition.\nWhich device do you want the new partition on?\n";
    &getDisks();
    my $disksfile = "/tmp/disks";
    my $counter = 1;
	my $diskchoice = 0;
    open(DISKSFH, $disksfile);
    my @disks = <DISKSFH>;
    close(DISKSFH);
    
    my @deviceoptions;
    
    #print menu with each device
    foreach my $line (@disks){
        chomp(my $devicename = $line);
        
        #get some details about the device
        chomp(my $sectorsize = `fdisk -luc $devicename 2>&1 | awk '\$0 ~ /Sector size/ { print \$4 }'`);
        chomp(my $totalsectors = `fdisk -luc $devicename 2>&1 | awk '\$0 ~ /heads/ { print \$8 }'`);
        `fdisk -luc $devicename 2>&1 | awk '(\$0 ~ /sd/ || \$0 ~ /md/) && \$0 !~ /Disk/ { print \$0 }' > /tmp/fdisk`;
        
        my $remainingsectors = $totalsectors;
        my $totalpartitions = 0;
        #get all partitions for device
        my @partitions = `fdisk -l $devicename 2>&1 | awk '(\$0 ~ /md/ || \$0 ~ /sd/) && \$0 !~ /Disk/ { print \$1 }'`;
        foreach my $part (@partitions){
			chomp($part);
            my @split = split("/",$part);    
            chomp(my $workingpart = $split[2]);
            
            chomp(my $isextended = `cat /tmp/fdisk | awk '/$workingpart/ && /Extended/ { ++x } END {if (x ==1) print "yes"; else print "no"}'`);
            chomp(my $isbootable = `cat /tmp/fdisk | awk '/$workingpart/ && /\\*/ { ++x } END {if (x == 1) print "yes"; else print "no"}'`);
    
        	my $sectorsused = 0;
        	if($isbootable =~ m/yes/){
        		chomp($sectorsused = `cat /tmp/fdisk | awk '\$0 ~ /$workingpart/ { print \$4-\$3 }'`);
        	}#end if
        	else{
        		chomp($sectorsused = `cat /tmp/fdisk | awk '\$0 ~ /$workingpart/ { print \$3-\$2 }'`);
        	}#end else
            
            if($isextended =~ m/no/){
                $remainingsectors = $remainingsectors - $sectorsused;
            }#end if
			
            $totalpartitions++;
		}#end foreach
        $remainingsectors = $remainingsectors - ($totalpartitions * 2048);
        my $remainingspace = &convertSize($remainingsectors*$sectorsize);
        if($remainingsectors > 4100){
            $deviceoptions[$counter] = $devicename;
            print "$counter - $devicename - $remainingspace available\n";
            $counter++;
        }#end if      
        
    }#end foreach
	$counter--;
    
    #get user input
    print "\nEnter a device number: ";
    chomp($diskchoice = <>);
	if (($diskchoice <= $counter) && ($diskchoice > 0)){
        my $workingdevice = $deviceoptions[$diskchoice];
		
        #see if there is an extended partition on specified device
        chomp(my $hasextended = `fdisk -luc $workingdevice 2>&1 | awk '/Extended/ { ++x } END {if ( x>=1 ) print "yes"; else print "no"}'`);
        if($hasextended =~ m/no/){
            print "\n\nThe device $workingdevice does not have a logical partition container. Would you like to create one now?\n\n";
            print "If you only want primary partitions type \"no\" and create them manually.\n";
            print "\n\nChoice (yes or no): ";
            chomp(my $extendchoice = <>);
            
            if($extendchoice eq "yes"){
                print "\n\nCreating logical partition container.\n";
                #New, Extended, 1 (partition number), default first sector, default last sector, Write
                open(OFILE, '>/tmp/ofile');
                print OFILE "n\ne\n1\n\n\nw\n";
                close(OFILE);
                `fdisk -uc $workingdevice 2>&1 < /tmp/ofile`;
            }#end if
        }#end if
        
        
        #see if there is an extended partition on specified device
        chomp(my $hasextended = `fdisk -luc $workingdevice 2>&1 | awk '/Extended/ { ++x } END {if ( x>=1 ) print "yes"; else print "no"}'`);
        if($hasextended =~ m/yes/){
            print "\n\n";
            print "What do you want to define the size of the partition in?\n";
            print "1 - Sectors\n";
            print "2 - KiloBytes\n";
            print "3 - MegaBytes\n";
            print "4 - GigaBytes\n";
            print "5 - TeraBytes\n";
            print "Choice: ";
            chomp(my $sizetype = <>);
            if(($sizetype >= 1) && ($sizetype <= 5)){
                #get all partitions for device
                my @partitions = `fdisk -l $workingdevice 2>&1 | awk '(\$0 ~ /md/ || \$0 ~ /sd/) && \$0 !~ /Disk/ { print \$1 }'`;
                chomp(my $sectorsize = `fdisk -luc $workingdevice 2>&1 | awk '\$0 ~ /Sector size/ { print \$4 }'`);
                chomp(my $totalsectors = `fdisk -luc $workingdevice 2>&1 | awk '\$0 ~ /heads/ { print \$8 }'`);
    
                my $remainingsectors = $totalsectors;
                my $totalpartitions = 0;
                foreach my $part (@partitions){
        			chomp($part);
                    my @split = split("/",$part);    
                    chomp(my $workingpart = $split[2]);
    
                    chomp(my $isextended = `fdisk -luc $workingdevice 2>&1 | awk '/$workingpart/ && /Extended/ { ++x } END {if (x ==1) print "yes"; else print "no"}'`);
                    chomp(my $isbootable = `fdisk -luc $workingdevice 2>&1 | awk '/$workingpart/ && /\\*/ { ++x } END {if (x == 1) print "yes"; else print "no"}'`);
            
                	my $sectorsused = 0;
                	if($isbootable =~ m/yes/){
                		chomp($sectorsused = `fdisk -luc $workingdevice 2>&1 | awk '\$0 ~ /$workingpart/ { print \$4-\$3 }'`);
                	}#end if
                	else{
                		chomp($sectorsused = `fdisk -luc $workingdevice 2>&1 | awk '\$0 ~ /$workingpart/ { print \$3-\$2 }'`);
                	}#end else
                    
                    if($isextended =~ m/no/){
                        $remainingsectors = $remainingsectors - $sectorsused;
                    }#end if
        			
                    $totalpartitions++;
        		}#end foreach
                $remainingsectors = $remainingsectors - ($totalpartitions * 2048);
                my $remainingspace = &convertSize($remainingsectors*$sectorsize);
                
                
                print "\n\n";
                print "Enter the size of the new partition in ";
                if($sizetype == 1){
                    print "sectors";
                }#end if
                elsif($sizetype == 2){
                    print "KB";
                }#end elseif
                elsif($sizetype == 3){
                    print "MB";
                }#end elseif
                elsif($sizetype == 4){
                    print "GB";
                }#end elseif
                elsif($sizetype == 5){
                    print "TB";
                }#end elseif
                print " (max of $remainingspace or $remainingsectors sectors): ";
                chomp(my $partsize = <>);
                
                #convert size of new partition to bytes
                if($sizetype == 1){
                    $partsize = $partsize * $sectorsize;
                }#end if
                if($sizetype >= 2){
                    $partsize = $partsize * 1024;
                }#end if
                if($sizetype >= 3){
                    $partsize = $partsize * 1024;
                }#end if
                if($sizetype >= 4){
                    $partsize = $partsize * 1024;
                }#end if
                if($sizetype >= 5){
                    $partsize = $partsize * 1024;
                }#end if
                
                #get new partition size in sectors
                my $partsizesectors = $partsize/$sectorsize;
                if($partsizesectors > 1000000){
                    $partsizesectors = $partsizesectors - 10;
                }#end if
                
                
                if($partsizesectors <= $remainingsectors){            
                    #do work
                    print "\n\n";
                    my $displaysize = &convertSize($partsize);
                    print "Are you sure you want to create a new partition that is $displaysize on $workingdevice?\n";
                    print "Type yes to create partition the partition, or no to cancel: "; 
                    
                    chomp(my $confirm = <>);
                    if($confirm =~ m/yes/){
                        #remove decimal places
                        $partsizesectors = sprintf("%.0f", $partsizesectors);
                        #New, Logical, default first sector, last sector, Write
                        open(OFILE, '>/tmp/ofile');
                        print OFILE "n\nl\n\n\+$partsizesectors\nw\n";
                        close(OFILE);
                        `fdisk -uc $workingdevice 2>&1 < /tmp/ofile`;
                    }#end if confirm
                    else{
                        print "\n\nWill not create partition.\n";
                    }#end else
    
                }#end if
                else{
                    print "\n\nInvalid size chosen.\n";
                }#end else
                
                
            }#end if sizetype choice
            else{
                print "\n\nInvalid size choice.\n";
            }#end else
        }#end if has extended partition
        else{
            print "\n\nPlease create your partitions manually.\n";
        }#end else
	}#end if device choice
    else{
        print "\n\nInvalid device choice.\n";
    }#end else
       
}#end function createNewPartition


#Function deletePartition
#Gives a list of partitions and allows them to be deleted.
#Params: n/a
#Returns: n/a
sub deletePartition{
    
    print "\n\n";
    print "Which partition do you want to delete?\n";
    
    #create list of disks in tmp file
	&getDisks();
    my $disksfile = "/tmp/disks";
    open(DISKSFH, $disksfile);
    my @disks = <DISKSFH>;
    close(DISKSFH);

    #run through each device
    my $counter = 1;
    my @allpartitions;
    foreach my $line (@disks){ 
        chomp(my $devicename = $line);

        #get all partitions for device
        my @partitions = `fdisk -luc $devicename 2>&1 | awk '\$0 ~ /sd/ && \$0 !~ /Disk/ { print \$1 }'`;
        foreach my $part (@partitions){
			chomp($part);
			print "$counter - $part\n";
            $allpartitions[$counter] = $part;
            $counter++;
		}#end foreach
    }#end foreach
    $counter--;
    
    print "Choice: ";
    chomp(my $choice = <>);
    
    if(($choice > 0) && ($choice <= $counter)){
        my $workingpartition = $allpartitions[$choice];
        print "\n\nAre you sure you want to delete $workingpartition?\n";
        print "Choice (yes or no): ";
        chomp(my $confirm = <>);
        
        if($confirm =~ m/yes/){
            my $workingdevice = $workingpartition;
            $workingdevice =~ s/[0-9]+//;
            my $partitionnum = $workingpartition;
            $partitionnum =~ s/\/dev\/[sh]d[a-z]//;
            #Delete, partition number, Write
            open(OFILE, '>/tmp/ofile');
            print OFILE "d\n$partitionnum\nw\n";
            close(OFILE);
            `fdisk -uc $workingdevice 2>&1 < /tmp/ofile`;
        }#end if confirm
        else{
            print "\n\nWill not delete $workingpartition.\n";
        }#end else
    }#end if valid partition
    else{
        print "\n\nInvalid partition.\n";
    }#end else
}#end function deletePartition


#Function createFilesystem
#Create a filesystem on a partition. Both the filesystem type and target partition are given as menu items.
#Params: n/a
#Returns: n/a
sub createFilesystem{
    
    print "\n\n";
    print "Create a filesystem\n";
    print "Which filesystem type do you want to use?\n";
    
    #get mkfs location
    chomp(my $mkfsloc = `which mkfs | awk '{sub(/mkfs/, "", \$0); print \$0}'`);

    
    #get all filesystems support by mkfs
    my @fsoptions = `ls $mkfsloc | awk 'BEGIN {FS = "\\."} \$0 ~ /mkfs\\./ && \$0 !~ /cramfs/ {print \$2}' | sort`;

    my $counter = 1;
    #print out each fs for user to select
    foreach my $fs (@fsoptions){
        chomp($fs);
        print "$counter - $fs\n";
        $counter++;
    }#end foreach
    $counter--;
    print "\nIf the filesystem you want to use is not displayed then it is not currently supported on your system by mkfs.\n";
    #get fs user wants to use
    print "Enter filesystem number: ";
    chomp(my $fsselect = <>);
    
    
    if(($fsselect > 0) && ($fsselect <= $counter)){
        #get the fs name from selection
        $fsselect = $fsselect - 1;
        $fsselect = $fsoptions[$fsselect];
        
        print "\n\nCreate a filesystem\n";
        print "Which partition do you want to format with $fsselect?\n";
        
        
        #create a list of each partition
        #create list of disks in tmp file
    	&getDisks();
        my $disksfile = "/tmp/disks";
        open(DISKSFH, $disksfile);
        my @disks = <DISKSFH>;
        close(DISKSFH);

        #make temp files for blkid and fstab
        `blkid 2>&1 > /tmp/blkid`;
        `cat /etc/fstab 2>&1 > /tmp/fstab`;
    
        $counter = 1;
        #run through each device
        my @availableparts;
        foreach my $devicename (@disks){ 
            chomp($devicename);
    
            #get all partitions for device
            my @partitions = `fdisk -luc $devicename 2>&1 | awk '\$0 ~ /sd/ && \$0 !~ /Disk/ { print \$1 }'`;
            foreach my $part (@partitions){
    			chomp($part);
                my @split = split("/",$part);    
                chomp(my $workingpart = $split[2]);

                #see if partition is extended
            	chomp(my $isextended = `fdisk -luc $devicename 2>&1 | awk '(\$0 ~ /sd/ || \$0 ~ /md/) && \$0 !~ /Disk/ { print \$0 }' | awk '/$workingpart/ && /Extended/ { ++x } END {if (x ==1) print "yes"; else print "no"}'`);
                
                #if part is not extended continue 
                if($isextended =~ m/no/){
                    #get UUID of partition
                	chomp(my $uuid = `cat /tmp/blkid | awk '\$0 ~ /$workingpart:/ { print \$2 }' | awk 'BEGIN { FS = "\\\"" }; { print \$2 }'`);
                	if(length($uuid) < 12){
                		$uuid = "None";
                	}#end if
                    
                    #see if the filesystem is mounted
                	chomp(my $mountloc = `cat /tmp/fstab | awk '\$0 ~ /$uuid/ { print \$2 }'`);
                    if(length($mountloc) < 1){
                        print "$counter - $part\n";
                        $availableparts[$counter] = $part;
                        $counter++;
                    }#end if                    
                }#end if not extended
    		}#end foreach partition
        }#end foreach device
        $counter--;
        
        #check there are partitions available
        if($counter > 1){
            print "\nEnter partition number: ";
            chomp(my $partitionchoice = <>);
            
            #check valid partition chosen
            if(($partitionchoice > 0) && ($partitionchoice <= $counter)){
                #get selected partition
                my $partselect = $availableparts[$partitionchoice];
                
                print "Are you sure you want to format $partselect with $fsselect?\n";
                print "Choice (yes or no): ";
                chomp(my $confirm = <>);
                
                if($confirm =~ m/yes/){
                    open(OFILE, '>/tmp/ofile');
                    print OFILE "yes\n";
                    close(OFILE);
                    `mkfs.$fsselect $partselect 2>&1 < /tmp/ofile > /dev/null`;
                }#end if
                else{
                    print "\nThe partition will not be formatted.\n";
                }#end else
            }#end if valid part
            else{
                print "\nInvalid partition.\n";
            }#end else
        }#end if available partitions found to format
        else{
            print "\nThere are no available unmounted partitions to format.\n";
        }#end else no available partitions
        
    }#end if valid fs type
    else{
        print "\nInvalid filesystem.\n";
    }#end else
}#end function createFilesystem


#Function mountFileSystem
#Mount unmounted filesystems. Also add them to fstab if desired.
#Params: n/a
#Returns: n/a
sub mountFileSystem {
    
}#end function mountFileSystem

#####
#EOF#
#####