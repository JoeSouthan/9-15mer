package MHCErrors;
use strict;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw (ErrorLength ChoiceMaker); 
our @EXPORT_OK = qw(ErrorLength ChoiceMaker); 

#Usage $processSeq $modeFlag $checkLineCounter $diffLength $tooLong $debugFlag
sub ErrorLength {
	#Error message
	my $lineNumber = $_[2]+1;
	my $abs = abs ($_[3]);
	if (1== $_[4]) {
			#Too long
				print "\n------ Warning ------\nInfo:\t". $_[1]."mer mode\n";
				print "Sequence length on line number $lineNumber is greater than ".$_[1].". \nLine was ".$_[3]." AA too long.\n";
				print "Please check mode or choose a cleaning mode:\n";
				print "Mode 1: Sequence will be condensed into a single line then chopped up into ".$_[1]."s (Recommended)\n";
				print "Mode 2: Remove terminal ammino acids on lines and remove lines smaller than ".$_[1].".\n\t(Will take into account length of lines.)\n";
				print "Please choose mode (1 or 2) or type N to cancel : ";
				ChoiceMaker($_[0], $_[4], $_[1]);

	} else {
			#Too short
				print "\n------ Warning ------\nInfo:\t". $_[1]."mer mode\n";
				print "Sequence length on line number $lineNumber is shorter than " .$_[1]. ". \n";
				print "Line was $abs AA too short.\n";
				print "Please check your mode or clean the file.\n";
				print "Entire sequence will be condensed into a single line then chopped up into ".$_[1]."s \n";
				print "Continue? Y/N :";
				ChoiceMaker($_[0], $_[4], $_[1]);
	
	}
				
}

#
sub ChoiceMaker {
	#Too Long
	
	if ($_[1] == 1) {
		#Parse the input
		my $chopper = <STDIN>;
		chomp $chopper;
			#Parse the user's choice.
			if ($chopper =~ /[1]/) {
				#Mode 1 fix
				print "\nWill now process sequence.\n";
				return $_[0]= 1;
			} elsif ($chopper =~ /[2]/) {
				#Mode 2 fix
				print "\nWill now process sequence.\n";
				return $_[0]= 2;
			} elsif ($chopper =~/[nN]/){
				die "\nPlease check over your sequence file and edit so that each sequence is only ".$_[2]." AA per line. \n"
			} elsif ($chopper =~/[^1|2|nN]/) {
				die "\nInvalid choice. \n"
			}
			
	} else {
	#Too Short
		#Parse the input
		my $chopper = <STDIN>;
		chomp $chopper;
			#Parse the user's choice.
			if ($chopper =~ /[1|yY]/) {
				#Mode 1 fix
				return $_[0]= 1;
				print "\nWill now process sequence.\n";
			} elsif ($chopper =~/[nN]/){
				die "\nPlease check over your sequence file and edit so that each sequence is only ".$_[2]." AA per line. \n"
			} elsif ($chopper =~/[^1|2|nN|yY]/) {
				die "\nInvalid choice. \n"
			}
		#Stop the loop
		last;
	}
}
1
