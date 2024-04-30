# Create the parameter file to run the script
# This is specific to the current directory structure but can be adapted for other contexts also. To adapt it, change the relative directory paths and try to run manually for an organism.
# This is only for tetrapods
#
use strict;
use warnings;

# Variables to make directories and the files
my @tetrapods = ('CARROT', 'TACGIG');
my @outgroups_2R = ('DERSIL','HAELON');


foreach my $tetra (@tetrapods){
	
	# Make directory structuure for fish and tetrapods
	print `mkdir $tetra`;
	print `mkdir $tetra\/outgroup`;
	print `mkdir $tetra\/self`;

	# Polyploid genomes --------------------------------------------------
	open PP2R, ">$tetra/outgroup/PolyploidGenomes.in" or die $!;
	print PP2R "$tetra	../gene_order/$tetra\_gene_order.tsv";
	close (PP2R);
	
	open SPP2R, ">$tetra/self/PolyploidGenomes.in" or die $!;
	print SPP2R "$tetra	../gene_order/$tetra\_gene_order.tsv";
	close (SPP2R);

	# Outgroup genomes --------------------------------------------------
	open OG2R, ">$tetra/outgroup/OutgroupGenomes.in";
	foreach my $og (@outgroups_2R){
		
		for (1..5){ # Window sized in the multiples of 100
			$_ = $_*100;
 		 	print OG2R "$og\_$_	../gene_order/$og\_gene_order.tsv\n";
		}
	}
	close (OG2R);

	open SOG2R, ">$tetra/self/OutgroupGenomes.in";
	for (1..5){ # Window sized in the multiples of 100
		$_ = $_*100;
	 	print SOG2R "$tetra\_$_	../gene_order/$tetra\_gene_order.tsv\n";
	}
	close (SOG2R);	
	
	# Run parameters -------------------------------------------------	
	open RP2R, ">$tetra/outgroup/RunParameters.in" or die $!;
	foreach my $og (@outgroups_2R){
		
		for (1..5){ # Window sized in the multiples of 100
			$_ = $_*100;
			print RP2R "$og\_$_	$tetra	$_	$_	2\n";
		}
	}
	close (RP2R);

	open SRP2R, ">$tetra/self/RunParameters.in" or die $!;
	for (1..5){ # Window sized in the multiples of 100
		$_ = $_*100;
		print SRP2R "$tetra\_$_	$tetra	$_	$_	2\n";
	}
	close (SRP2R);
	
	# Ortholog files --------------------------------------------------
	open ORTH2R, ">$tetra/outgroup/OrthologFiles.in" or die $!;
	foreach my $og (@outgroups_2R){
		
		for (1..5){ # Window sized in the multiples of 100
			$_ = $_*100;
 		 	print ORTH2R "$og\_$_	$tetra	../orthologs/$tetra\_$og\_orthologs.tsv\n"; 
		}
	}
	close (ORTH2R);

	open SORTH2R, ">$tetra/self/OrthologFiles.in" or die $!;
	for (1..5){ # Window sized in the multiples of 100
		$_ = $_*100;
	 	print SORTH2R "$tetra\_$_	$tetra	../paralogs/$tetra\_$tetra\_paralogs.tsv\n"; 
	}
	close (SORTH2R);
	
}


