# This calculates the phylogenetically biased q-score and final ohnolog pairs for filtering.
# The output is all the candidate ohnologs combined from all outgroups, windos, and vertebrates.
# I calculate 2 q-scores for each probability -> a global with all vertebrates and one for each of the 3 major groups. We are using glocal q-score for now.
# ****************************************
use strict;
use warnings;
use Statistics::Descriptive;

local $| = 1;

# --------------------------------------------------------------------------------------------------------------------

my @allorgs = ('CARROT', 'TACGIG');

# --------------------------------------------------------------------------------------------------------------------

foreach my $organism (@allorgs){
	
#if ($organism eq 'ARGBRU'){ # test for one organism

	print "> Combining $organism\n";
	my $infile = "$organism/$organism\_allSpiders.txt";
	my $outfile = "$organism/$organism\_allSpiders_withGeoMean.txt";
	print "  INPUT:  $infile\n";
	print "  OUTPUT: $outfile\n";

	open CONSENSUS, $infile or die $!; # Open Consensus file 
	open OUT, ">$outfile" or die $!; # Open outfile
	
	# ----------------------------------------------------------------------------------------
	# Arrays to hold the index of the groups --> This will be decided based on the header lines and then applied to rest of the lines

	my %globalindex;

	# ----------------------------------------------------------------------------------------
	# Foreach gene
	my $linecount = 0; # This is just to print the stuff once inside the loop below
	while (<CONSENSUS>){
	
		my @line = split "\t", $_;
		map {$_=~s/\t|\n//g} @line;
		$linecount++;

		# ----------------------------------------------------------------------------------------
		# Print the header and get the index of the self and outgroup q-score for all organisms that needs to be averaged				
		if ($_ !~/^(CARROT|TACGIG).+/){
		
			# Check the order in the header file

			print OUT join ("\t", @line[0..2]),"\t";
			print OUT "$organism mult. P-og(>=k)\t$organism P-self(>=k)\t"; 
			print OUT "Og weighted global mean\tSelf weighted global mean\t"; # Global q-score
			print OUT join ("\t", @line[4..5]),"\t"; 
			print OUT join ("\t", @line[7..$#line]),"\n";
			
			# Global index with all the organisms
			my $refG = getIndex(\@line, \@allorgs); # ALL ORGANISMS
			%globalindex = %{$refG};
			
			next;
			
		};

		# Print some of the values, I'll print rest of the ones after global index below
		print OUT join ("\t", @line[0..3]),"\t";
		print OUT "$line[6]\t";

		
		# ----------------------------------------------------------------------------------------
		
		# ----------------------------------------------------------------------------------------
	
		
		# Open the weight file and read in the weights in GlobalWeights hash
		my %GlobalWeights; # global weights
		open GWF, "spiders_weights.txt" or die $!;
		foreach (<GWF>){
			my @wghts = split "\t", $_;
			map {$_=~s/\t|\n//g} @wghts;
			#print "$wghts[1]\t$wghts[3]\n";
			$GlobalWeights{$wghts[1]} = $wghts[3]

		}
		close (GWF);
				
		# ----------------------------------------------------------------------------------------		
		# Now add the values for the current organism that could not be added in the subroutein. See NOTE in the subroutein.
		$globalindex{$organism}{'og'} = 3; # Index for outgroup for self organism, check!
		$globalindex{$organism}{'self'} = 6; # Index for self for self organism, check!


		# ----------------------------------------------------------------------------------------		
		# Calculate global q-score
		# Q-score formula is: qscore^k = Exp[ Sum_{species i in group k or global} p^k_i log(species i qscore)] (see email by HI)
		# For global q score the weights will be from all-vertebrates file
		my $sumogGlobal = 0; my $sumselfGlobal = 0;
		#print "$line[2] - $line[3]\tGLOBAL\n";
		# Foreach organism, weighted sum of global q-scores
		foreach my $organ (keys %globalindex){
						
			#print "$organ\t", $globalindex{$organ}{'og'},"\t", $globalindex{$organ}{'self'}, "\n";
			
			# Calculate for outgroups ---------------------			
			if ($line[$globalindex{$organ}{'og'}] ne ''){ # If the value exists for this outgroup
				#print "$organ\t", $line[$globalindex{$organ}{'og'}], "\t", log($line[$globalindex{$organ}{'og'}]), "\t", $GlobalWeights{$organ}, "\t", (log($line[$globalindex{$organ}{'og'}]) * $GlobalWeights{$organ}), "\n";
				$sumogGlobal = $sumogGlobal + (log($line[$globalindex{$organ}{'og'}]) * $GlobalWeights{$organ})
			}

			# Calculate for self ---------------------		
			if ($line[$globalindex{$organ}{'self'}] ne ''){ # If the value exists for this outgroup
				#print "$organ\t", $line[$globalindex{$organ}{'self'}], "\t", log($line[$globalindex{$organ}{'self'}]), "\t", $GlobalWeights{$organ}, "\t", (log($line[$globalindex{$organ}{'self'}]) * $GlobalWeights{$organ}), "\n";
				$sumselfGlobal = $sumselfGlobal + (log($line[$globalindex{$organ}{'self'}]) * $GlobalWeights{$organ})
			}			
		}
		
		# print global averages and rest of the lines
		print OUT exp($sumogGlobal), "\t";
		print OUT exp($sumselfGlobal), "\t";
		
		print OUT join ("\t", @line[4..5]),"\t"; 
		print OUT join ("\t", @line[7..$#line]),"\n";
	

		# test print global averages
		#print $sumogGlobal, "\t", exp($sumogGlobal), "\n";
		#print $sumselfGlobal, "\t", exp($sumselfGlobal), "\n";

	}
	close (CONSENSUS);

#} # end test for one organism
}



sub getIndex {
	
	my $lineref = shift; 
	my @line = @$lineref;
	my $orgref = shift;
	my @orgs = @$orgref;
	
	my @ind; my %index;
	foreach my $org (@orgs){
		
#		print "$org\t";
		@ind = grep { $line[$_] =~ /$org/ } 0..$#line; # The @ind here will have 3 columns that have the organims names. 0: gene symbols; 1: p_og; 2: p_self. I will extract the p_og and self later
#		print "*@ind*\n";
		$index{$org}{'og'} = $ind[1];
		$index{$org}{'self'} = $ind[2];
		#print "@index\n";
	}	
	return (\%index);
	# NOTE: Remember that the values for self organism here are blank. I will add these values later.
}


