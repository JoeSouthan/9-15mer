package MHCRoutines;
use strict;
use Exporter;
use MHCErrors;
our @ISA = qw(Exporter);
our @EXPORT = qw (CheckFile LoadSeqs CheckExisting CleanSeqs); 
our @EXPORT_OK = qw(CheckFile processSeq LoadSeqs CheckExisting CleanSeqs); 

#Usage $existingCleaned $processSeq $modeFlag $file
sub CheckExisting {
	if (open SEQS, "$_[3]_clean_$_[2]_mers.txt") {

		#File exists, time to go back.
		if ($_[1] == 1 or $_[1] == 2){
			print "Cleaned file created successfully\n";
		}else{
			print "A cleaned file exists.\nUsing this.\n\n";
		}
		return $_[0] = 1;
	}
	print "File OK.\n\n";
}

#Usage @Seqs $processSeq $modeFlag $file $existingCleaned $debug
sub LoadSeqs {
	my $file = "$_[3]";
	if ($_[4] == 1) {
		$file = "$file\_clean_$_[2]_mers.txt";
	}
	my @SeqsIn;
	open (SEQS, $file) or die ("Can't open Sequence file. Please check path. \n");
		while (my $line = <SEQS>) {
			if ($line =~ /([A-Z]+)\n/){
				push (@SeqsIn, $1);
			}
		}
	close (SEQS) or die ("Can't close sequence file.\n");
	print "Sequences Loaded.\n\n";
	
							#Debug
							
							if ($_[5] == 1) {
								my $debugcount=1;
								print "---Loaded Sequences ---\n\n";
								print "Sequence (Length)\n";
								foreach my $seqs (@SeqsIn) {
									my $length = length $seqs;
									print "$debugcount $seqs ($length)\n";
									$debugcount++;
								}
								print "-----------------------\n\n";
							}
	
	return $_[0] = \@SeqsIn;
	
	
}

#Usage @Seqs $processSeq $modeFlag @lengthCount $existingcleaned $debugMode
sub CheckFile {

	#If this is a cleaned file skip this
	if ($_[4] == 1) {
	}else{
	my @localSeqs = @{$_[0]};
	my @lengthCount;
	
	#Check each seq. Score by length
	foreach my $sequences (@localSeqs) {
		my $linelength = length $sequences;
		my $linediff = $linelength - $_[2];
			if ($linelength > $_[2]) {
				push (@lengthCount, "$linediff");
			} elsif ( $linelength < $_[2]) {
				push (@lengthCount, "$linediff");
			} elsif ($linelength == $_[2]) {
				push (@lengthCount, "$linediff");
			} 
		}
	

	#Scan through to look for sequences that are too long/short
	my $tooLong = 0;
	
	for (my $i = 0; $i < @lengthCount; $i++) {
		my $diffLength = $lengthCount[$i];
		if ($diffLength <= -1) {
			ErrorLength($_[1], $_[2], $i, $diffLength, $tooLong);
			last;
		} elsif ($diffLength >= 1) {
			$tooLong = 1;
			ErrorLength($_[1], $_[2], $i, $diffLength, $tooLong);
			return $_[3] = \@lengthCount;
			last;
		} elsif ( 0 == $diffLength) {
		}
	}
}

}

#Usage @Seqs $processSeq $modeFlag $debugMode
sub CleanSeqs {
	my $saveFile = "$_[3]_clean_$_[2]_mers.txt";
	
	#Dereference arrays
	my @localSeqs = @{$_[0]};
	my @cleanedSeqs;
	
	#Mode Selection
	if ($_[1] == 1) {
		#Mode 1
		#	Colapase to string then recut and return
		my $flatSeq;
		#Collapse
		foreach my $seqs (@localSeqs) {
			$flatSeq .= $seqs;
		}
		#Recut
		#	How long is the new string?
		my $lengthLoop = int ((length ($flatSeq)/$_[2]) + 1); #+1 accounts for extra lines that may be < 9
		
		#Separate into 9/15mers
		my $offset = 0;
		for (my $j = 0; $j < $lengthLoop; $j++) {
			$cleanedSeqs[$j] = substr ( $flatSeq , $offset, $_[2]);
			$offset += $_[2];

		}
		
		#A check for 9 and 15 mode. Checks to see if a sequence is >9
		my $lastElement = length ($cleanedSeqs[$#cleanedSeqs]); 
		
		if ($lastElement < $_[2] and $_[2] == 9) {
			pop @cleanedSeqs;
		} elsif ($lastElement < $_[2] and $lastElement > 9 and $_[2] == 15) {
		} elsif ($lastElement < $_[2] and $lastElement <= 8 and $_[2] == 15){
			pop @cleanedSeqs;
		}
		
		#Offer to save the file.
		print "Would you like to save this cleaned file? [Y/N]\n";
		my $chomper = <STDIN>;
		chomp $chomper;
		if ($chomper =~ /[yY]/ ){
			print "--- Starting Clean --- \n";
			open (SAVECLEAN, ">", "$saveFile") or die ("Can't open output file\n");
				foreach my $entries (@cleanedSeqs) {
						print SAVECLEAN "$entries\n";
				}
			print "Saved to $saveFile \n";
			print "--- Finished Clean ---\n\n";
			close SAVECLEAN or die ("Can't close file\n");
			return $_[0] = \@cleanedSeqs;
		} elsif ( $chomper =~ /[nN]/) {
			#Just return the array
			return $_[0] = \@cleanedSeqs;
		} else { 
			die "Invalid Choice\n";
		}
								#Debug
								if ($_[4] == 1) {
									print "---Cleaned Sequences ---\n";
									foreach my $seqs (@cleanedSeqs) {
										my $length = length ($seqs);
										print "$seqs $length\n";
									}
									print "------------------------\n";
								}
		
			
	} elsif ($_[1] == 2){
		

		#Mode 2
		#	Removes terminal AAs
		my $j = 0;
		for (my $i = 0; $i < @localSeqs; $i++) {
			my $length = length $localSeqs[$i];

			#Check if there are some useful AAs to be had and shove into the array.
			if ($length > $_[2] ){
				my $frame = int ($length/$_[2]);
				my $offset = 0;
				for (my $k =0 ; $k < $frame; $k++){
					$cleanedSeqs[$j] = substr($localSeqs[$i], $offset, $_[2]);
					$offset += $_[2];
					$j++;

				}
			} elsif ($length < $_[2]) {
						#Debug
						if ($_[4] == 1){
							print "Discarded $localSeqs[$i], length $length.\n";
						}
			}
		}
		
		
		#Recheck for 15 weirdness
		#Make sure we don't loose something that could work in the matching sub
		my $lastElement = length ($cleanedSeqs[$#cleanedSeqs]);
		
		if ($lastElement < $_[2] and $_[2] == 9) {
			pop @cleanedSeqs;
		} elsif ($lastElement < $_[2] and $lastElement > 9 and $_[2] == 15) {
		} elsif ($lastElement < $_[2] and $lastElement <= 8 and $_[2] == 15){
			pop @cleanedSeqs;
		}
		
		#Offer to save the file.
		print "Would you like to save this cleaned file? \n";
		my $chomper = <STDIN>;
		chomp $chomper;
		if ($chomper =~ /[yY]/ ){
			print "--- Starting Clean --- \n";
			open (SAVECLEAN, ">", "$saveFile") or die ("Can't open output file\n");
				foreach my $entries (@cleanedSeqs) {
						print SAVECLEAN "$entries\n";
				}
			print "Saved to $saveFile \n";
			print "--- Finished Clean ---\n\n";
			close SAVECLEAN or die ("Can't close file\n");
			return $_[0] = \@cleanedSeqs;
		} elsif ( $chomper =~ /[nN]/) {
			return $_[0] = \@cleanedSeqs;
		} else { 
			die "Invalid Choice\n";
		}
		
	} 
	
}

1;
