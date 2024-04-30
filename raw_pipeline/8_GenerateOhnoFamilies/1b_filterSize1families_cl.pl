# As I combine ohnologs from all vertebrates, it can happen that some ohnolog pairs still are 
# within the smallest window (because they are outside the smallest window in other vertebrates).
# Such ohnologs are listed as size 1 family and I remove them here.
# This will generate a family with the same name.
use strict;
use warnings;

# --------------------------------------------------------------------------------------------------------------------
my @allorgs = ('CARROT', 'TACGIG');

# get command line arguments
my $organism = $ARGV[0];
my $criteria = $ARGV[1];

if ((scalar @ARGV) != 2){
	
	print "Script takes 2 arguments:
	1st: organism name e.g. hsapiens
	2nd criteria (0, A, B or C)
	
	Example usage: 1_DepthFirstSearchOhnolgFamilies_cl.pl drerio A _3R\n\n";
	print "Check parameters. Criteria can only be 0, A, B or C. Organism name must be one of the following\n";
	print "@allorgs\n\n";
	exit;
}

# --------------------------------------------------------------------------------------------------------------------

my $familyFile = "$organism\/Families_Criteria-[$criteria]_$organism".".txt";

print "> Processing $organism criteria $criteria\n";
print "  Family file: $familyFile\n";
print "  Removed families: ";

open FAM, "$familyFile" or die "$! $familyFile\n";
my @family = <FAM>;
close (FAM);

# open outfile with the same name
open OUT, ">$familyFile" or die "$!. Could not open $familyFile for writing\n";
my $famcount = 0;
foreach (@family){
	
	my ($size, $fam) = split ("\t", $_, 2);
	#print "$fam";
	if ($size == 1){
		print "  - $size\t$fam";
		$famcount++;
	}
	else {
		print OUT "$size\t$fam";	
	}
}
print "total_removed = $famcount\n\n";
