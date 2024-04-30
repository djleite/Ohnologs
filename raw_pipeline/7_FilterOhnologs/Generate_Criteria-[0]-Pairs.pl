# Filter ohnologs for diferent criteria
# No warnings allowed.
use strict;
use warnings;

# --------------------------------------------------------------------------------------------------------------------

# Columns with geo. mean of the final OUTGROUP and SELF q scores
my $og = 5; # A number more than columns, so we get a warning
my $self = 6;


# --------------------------------------------------------------------------------------------------------------------

my @allorgs = ('CARROT', 'TACGIG');


foreach my $organism (@allorgs){ # Process each organism one by one 
	
#	if ($organism eq 'hsapiens'){ # test for 1 org
	
	print "> Processing $organism\n";	
    print "  Filtering based on *** GLOBAL *** q-score\n";
    print "  Index for outgroup q-score =  $og & self q-score = $self. Check again (Column = Index + 1)!\n";
	print "  INPUT: ../6_CombineAllVertebrates/$organism\/$organism\_allSpiders_withGeoMean_filtered.txt\n";

	open FH, "../6_CombineAllVertebrates/$organism\/$organism\_allSpiders_withGeoMean_filtered.txt" or die $!;
	
	# Open outfile	
	my $outfile = "$organism\/".$organism.'_Criteria-[0]-Pairs.txt';
	print "  OUTFILE: $outfile\n\n";	
	open OUT, ">$outfile" or die $!;
	
	while (<FH>){

		my @line = split "\t", $_;
		map {$_=~s/\n//g} @line;		
	
	   if ($line[0] !~/^(CARROT|TACGIG).+/){print OUT $_; next;} # Print and skip to next for header
		
		# Criteria [AA]
		if ($line[$og] ne '' && $line[$self] ne '' && $line[$og] < 0.001 && $line[$self] < 0.001){
			print OUT "$_";
		}
	}
#	} # end test for 1 org
}

