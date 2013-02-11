#!/usr/bin/perl -w
use strict;
use lib "$ENV{PWD}/modules"; 
use MHCRoutines;
use MHCMatcher;

#	Perl script to check for binding specification for 9mers and 15mers 
#	to Class I and II MHC molecules. Will score each sequence 
# 	accordingly based on mode.
#
#	Written by: 		Joseph Southan
#	Date:				12/11/12
#	Example Usage:		./mhc.pl [1] [2] (-d)
#			[1]	 = Any text file
#			[2]  = Mode flag, -9 or -15 for 9mer or 15mer respectivly
#			(-d) = Debug (prints useful info)
#
#	Requires directory ./output/
#

#
#	Check the user input
#
		if (1 >= scalar(@ARGV)) {
			die "Not enough parameters. Example ./mhc.pl filename.txt -9 \n";
		} 

	#Check output exists
		unless (-d "output") {
			die "Output directory /output/ does not exist.\n";
		}

	#What mode are we going for?
		my $modeFlag = 0;
		if ("-9" eq $ARGV[1]) {
			$modeFlag = 9;
		} elsif ("-15" eq $ARGV[1]) {
			$modeFlag = 15;
		} elsif ( "-15" || "-9" != $ARGV[1] ) {
			die "Flag must be -15 or -9\n";
		}
		
	
		my $file = $ARGV[0];

	#Are we debugging?
		my $debugMode = 0;
		if (defined($ARGV[2]) and $ARGV[2] eq "-d" ) {
			$debugMode = 1;
		}
		
		
#
#	Welcome
#
	system("clear");
	print "\n---- MHC Class I/II matcher ----\n\n";
#
#	Check the file
#
	#Check Existance of a cleaned file
		my $processSeq = 0;
		my $existingCleaned = 0;
		print "(1/4) - Checking file...\n\n";
		CheckExisting($existingCleaned, $processSeq, $modeFlag, $file, $debugMode);
	
	# Load the Sequences
		my @Seqs;
		print "(2/4) - Loading Sequences...\n\n";
		my $doLoadSeqs = LoadSeqs(\@Seqs, $processSeq, $modeFlag, $file, $existingCleaned, $debugMode);
		@Seqs = @{$doLoadSeqs};
	
	#check the file based on mode.
		my @lengthCount;
		print "(3/4) - Checking sequences...\n\n";
		my $doCheck = CheckFile(\@Seqs, $processSeq, $modeFlag, \@lengthCount, $existingCleaned, $debugMode);

	#Retrieve lengths for modifying if too long
		unless (0 == $processSeq){
			print "-Cleaning- \n";
			my $doClean = CleanSeqs(\@Seqs, $processSeq, $modeFlag, $file, $debugMode);
			@Seqs = @{$doClean};
		}
	
	#Reassure the user. This is vital.
		print "Your file and sequences seem to be OK!\nMoving on.\n\n";


#
#	Actually do the matching
#
		print "(4/4) - Matching...\n";
		Matcher(\@Seqs,$modeFlag, $debugMode);

#
#	Debug Central.
#

		if (1 == $debugMode){
			my $debugcount=1;
			my $seqno = @Seqs;
			print "\n---- Debug -----\n";
			print "Mode = $modeFlag.\n";
			print "Processed? = $processSeq.\n";
			print "Sequences $seqno\n";
			print "----------------\n";
		}

