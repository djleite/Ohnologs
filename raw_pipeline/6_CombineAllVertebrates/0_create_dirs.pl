# Create the output directory structure
#

use strict;
use warnings;

# Variables to make directories and the files
my @tetrapods = ('CARROT', 'TACGIG');

# Make directory structuure for fish and tetrapods

foreach my $tetra (@tetrapods){	
	
	if (!-e $tetra){
		print `mkdir $tetra`;
	}
	else {
		print "Directory $tetra already exists, check and make sure all is well!\n";
	}
}


print `date`;


