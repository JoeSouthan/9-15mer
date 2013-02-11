Coursework for BioComputing 1 by Joseph Southan.

--mhc.pl--
mhc.pl contains the matching script to match a given sequence file. 

It can be run by using:
	./mhc.pl [0] [1] (-d)
	
	[0] = File.
	[1] = Mode. Can be 9 or 15.
	Optionally, -d will provide debug data to the screen.
	
	Example: ./mhc.pl seqs/sampleseqs.txt -9
			 Will match the contents of sampleseqs.txt using 9mer mode.
	
The script requires that there be a writeable /output/ directory in the same directory as mhc.pl.
Modules do not need to be installed and will run from the script.

Sample output is provided in /output/.

--test-scripts/seqgen.pl--
To generate sequences to test with mhc.pl navigate to test-scripts and run seqgen.pl as so:

	./seqgen.pl [0] [1] [2]
	
	[0] = Mode. 9 or 15 only when [2] is 1. Can be any number when [2] is 0.
	[1] = Number of sequences.
	[2] = Accuracy. 0 or 1. Whether to generate sequences entirely randomly or to ensure that 20% of sequences generated will be matches in mhc.pl.
	
	Example: ./seqgen.pl 9 100 1	
	
	This will generate 100 9mers with 20% of the sequences being matches.
	See file for more info.

Script requires that ../seqs and ../seqs/info be created and writeable.


Contents:
mhc.pl
/modules
	-MHCErrors.pm
	-MHCMatcher.pm
	-MHRoutines.pm
/output
	-Output_-9mer_1353889532.txt
	-Output_-15mer_1353889554.txt
/seqs
	/info/
		-info_100_generated_9_mers_1353889444.txt
		-info_100_generated_15_mers_1353889451.txt
		
	-acc_100_generated_9_mers_1353889444.txt
	-acc_100_generated_15_mers_1353889451.txt
	-sampleseqs.txt
/test-scripts
	-seqgen.pl
