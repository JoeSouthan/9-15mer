package MHCMatcher;
use strict;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw (Matcher MHC1_X1A MHC1_X2A MHC1_X2B MHC2_XX100 MHC2_XX112 MHC2_XX200 DoOutput);
our @EXPORT_OK = qw(Matcher); 

#Usage @Sequence $modeFlag $debugMode
sub Matcher {
	my @localSequences = @{$_[0]};
	my %seqScores1;
	my %seqScores2;
	my %seqScores3;
	my %seqComb;
	if ($_[1] == 9) {
		my $mhc1Count = 0;
		my $mhc2Count = 0;
		my $mhc3Count = 0;
		
		for (my $i = 0; $i < @localSequences; $i++) {
			#Do matches
			my $localscore = 0;
			my $MHC1 = MHC1_X1A($localSequences[$i]);
			my $MHC2 = MHC1_X2A($localSequences[$i]);
			my $MHC3 = MHC1_X2B($localSequences[$i]);
				if (1 == $MHC1) {
					$mhc1Count++;
					$localscore++;
					$seqScores1{$localSequences[$i]} = $i;
				}
				if (1 == $MHC2) {
					$mhc2Count++;
					$localscore++;
					$seqScores2{$localSequences[$i]} = $i;
				}
				if (1 == $MHC3) {
					$mhc3Count++;
					$localscore++;
					$seqScores3{$localSequences[$i]} = $i;
				}
			
		
			$seqComb{$localSequences[$i]} = $localscore;
		}
										#Debug
										if ($_[2] == 1){
											print "\n--- Debug: Final Counts---\n";
											print "MHC1_X1A = $mhc1Count\n";
											print "MHC1_X2A = $mhc2Count\n";
											print "MHC1_X2B = $mhc3Count\n";
											print "--------------------------\n";
										}
	#Output the values to a file
	DoOutput($mhc1Count, $mhc2Count, $mhc3Count, \%seqScores1, \%seqScores2, \%seqScores3, \%seqComb, $_[2]);

	
		
	} elsif ($_[1] == 15) {
		#15mer
		my $mhc1Count = 0;
		my $mhc2Count = 0;
		my $mhc3Count = 0;
		
		for (my $i = 0; $i < @localSequences; $i++) {
			#Do matches
			my $length = length $localSequences[$i];
			my $localscore = 0;
			my $diffCalc = $length - 8; #Allows for shorter sequences than 15 to be matched

			
			for (my $j = 0; $j < $diffCalc; $j++) {
				my $sequence = substr ($localSequences[$i], $j, 9);
				
					my $MHC1 = MHC2_XX100($sequence);
					my $MHC2 = MHC2_XX112($sequence);
					my $MHC3 = MHC2_XX200($sequence);
						if (1 == $MHC1) {
							$mhc1Count++;
							$localscore++;
							$seqScores1{$localSequences[$i]} = $i;
						} 
						if (1 == $MHC2) {
							$mhc2Count++;
							$localscore++;
							$seqScores2{$localSequences[$i]} = $i;
						}
						if (1 == $MHC3) {
							$mhc3Count++;
							$localscore++;
							$seqScores3{$localSequences[$i]} = $i;
						} 
			$seqComb{$localSequences[$i]} = $localscore;
		}
								
	}
										#Debug
										if ($_[2] == 1){
											print "\n--- Debug: Final Counts---\n";
											print "MHC2_X100 = $mhc1Count\n";
											print "MHC2_X112 = $mhc2Count\n";
											print "MHC2_X200 = $mhc3Count\n";
											print "--------------------------\n";
										}
	#Output the file
	DoOutput($mhc1Count, $mhc2Count, $mhc3Count, \%seqScores1, \%seqScores2, \%seqScores3, \%seqComb, $_[2]);

	}

}




#MHC1 Matchers
sub MHC1_X1A {
	# 1 = A G P
	# 3 = N D
	# 6 = F
	# 9 = A G
	if ($_[0] =~ /^[A|G|P].[N|D]..[F]..[A|G]$/){
		return 1;
	} else {
		return 0;
	}
}
sub MHC1_X2A {
	# 1 = A
	# 4 = Y
	# 6 = D L I
	# 9 = G R
	if ($_[0] =~ /^[A]..[Y].[D|L|I]..[G|R]$/){
		return 1;
	} else {
		return 0;
	}
}
sub MHC1_X2B {
	# 1 = A R T
	# 3 = A N
	# 5 = S
	# 9 = A R T
	if ($_[0] =~ /^[A|R|T].[A|N].[S]...[A|R|T]$/){
		return 1;
	} else {
		return 0;
	}
}

#MHC2 Matchers
sub MHC2_XX100 {
	# 1 = G
	# 3 = P
	# 6 = R A
	# 9 = A G
	if ($_[0] =~ /^[G].[P]..[R|A]..[A|G]$/){
		return 1;
	} else {
		return 0;
	}
}
sub MHC2_XX112 {
	# 1 = A G
	# 4 = I D 
	# 6 = L 
	# 9 = R D T
	if ($_[0] =~ /^[A|G]..[I|D].[L]..[R|D|T]$/){
		return 1;
	} else {
		return 0;
	}
}
sub MHC2_XX200 {
	# 1 = A T
	# 3 = S I
	# 5 = Y 
	# 9 = G
	if ($_[0] =~ /^[A|T].[S|I].[Y]...[G]$/){
		return 1;
	} else {
		return 0;
	}
}


#Usage $mhc1Count, $mhc2Count, $mhc3Count, \%seqScores1, \%seqScores2, \%seqScores3, \%seqComb
sub DoOutput {
		my $time = time;
		my $fileName = "$ARGV[1]mer_$time.txt";

		open (OUTPUT , ">", "output/Output_$fileName") or die "Can't create output file \n.";
	
		my %Seq1 = %{$_[3]};
		my %Seq2 = %{$_[4]};
		my %Seq3 = %{$_[5]};
		my %SeqComb = %{$_[6]};
		
		#Print out the sequences
		if ($ARGV[1] == 9){
		print "\n---Final Counts---\n";
		print "MHC1 X1A = $_[0]\n";
		print "MHC1 X2A = $_[1]\n";
		print "MHC1 X2B = $_[2]\n";

		print OUTPUT  "\n---Final Counts---\n";
		print OUTPUT  "MHC1 X1A = $_[0]\n";
		print OUTPUT  "MHC1 X2A = $_[1]\n";
		print OUTPUT  "MHC1 X2B = $_[2]\n";
							#Debug
							if ($_[7] == 1) {
								print OUTPUT  "\nMHC1 X1A matches (Sequence: line):\n";
								foreach (sort {$Seq1{$a} <=> $Seq1{$b}} keys %Seq1) {
										if ($Seq1{$_} > 0) {
											print OUTPUT "$_: $Seq1{$_}\n";
										}
								}
								print OUTPUT  "\nMHC1 X2A matches (Sequence: line):\n";
								foreach (sort {$Seq2{$a} <=> $Seq2{$b}} keys %Seq2) {
										if ($Seq2{$_} > 0) {
											print OUTPUT "$_: $Seq2{$_}\n";
										}		
								}
								print  OUTPUT "\nMHC2 X2B matches (Sequence: line):\n";
								foreach (sort {$Seq3{$a} <=> $Seq3{$b}} keys %Seq3) {
										if ($Seq3{$_} > 0) {
											print OUTPUT "$_: $Seq3{$_}\n";
										}			
								}
							} 
			if (scalar (keys %SeqComb) > 0) {
					print OUTPUT "\nSequence Scores:\n";
					foreach (sort {$SeqComb{$b} cmp $SeqComb{$a}} keys %SeqComb) {
						if ($SeqComb{$_} > 0) {
							print OUTPUT "$_: $SeqComb{$_}\n";
						}
				}	
			}
		} else {
		print "\n---Final Counts---\n";
		print "MHC2 1.0.0 = $_[0]\n";
		print "MHC2 1.1.2 = $_[1]\n";
		print "MHC2 2.0.0 = $_[2]\n";
		
		
		print OUTPUT  "\n---Final Counts---\n";
		print OUTPUT  "MHC2 1.0.0 = $_[0]\n";
		print OUTPUT  "MHC2 1.1.2 = $_[1]\n";
		print OUTPUT  "MHC2 2.0.0 = $_[2]\n";
							#Debug
							if ($_[7] == 1) {
								print OUTPUT  "\nMHC2 1.0.0 matches (Sequence: line):\n";
								foreach (sort {$Seq1{$a} <=> $Seq1{$b}} keys %Seq1) {
										if ($Seq1{$_} > 0) {
											print OUTPUT "$_: $Seq1{$_}\n";
										}
								}
								print OUTPUT  "\nMHC2 1.1.2 matches (Sequence: line):\n";
								foreach (sort {$Seq2{$a} <=> $Seq2{$b}} keys %Seq2) {
										if ($Seq2{$_} > 0) {
											print OUTPUT "$_: $Seq2{$_}\n";
										}		
								}
								print  OUTPUT "\nMHC2 2.0.0 matches (Sequence: line):\n";
								foreach (sort {$Seq3{$a} <=> $Seq3{$b}} keys %Seq3) {
										if ($Seq3{$_} > 0) {
											print OUTPUT "$_: $Seq3{$_}\n";
										}			
								}
							} 
			if (scalar (keys %SeqComb) > 0) {
					print OUTPUT "\nSequence Scores:\n";
					foreach (sort {$SeqComb{$b} cmp $SeqComb{$a}} keys %SeqComb) {
						if ($SeqComb{$_} > 0) {
							print OUTPUT "$_: $SeqComb{$_}\n";
						}
				}	
			}
		}
		print "\n---Complete---\n";
		print "Matching sequences written to /output/Output_$fileName\n\n";
		close (OUTPUT) or die ("Can't close output file\n");
}
1;
