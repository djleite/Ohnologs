# Create the output directory structure for tetrapods
#
use strict;
use warnings;

# Variables to make directories and the files
my @tetrapods = ('ARGBRU', 'DYSSIL', 'TRIANT');

foreach my $tetra (@tetrapods){
	
	# Make directory structure
	print `mkdir $tetra`;
	print `mkdir $tetra\/outgroup`;
	print `mkdir $tetra\/self`;
	
}

print `date`;
