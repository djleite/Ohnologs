# Combine self and outgroup probability (q-score) values.

use strict;
use warnings;

# FISH: 'gaculeatus', 'olatipes', 'tnigroviridis', 'drerio', 'trubripes'
# TETRAPODS: 'acarolinensis', 'fcatus','ggallus', 'ptroglodytes', 'btaurus', 'cfamiliaris', 'ggorilla', 'ecaballus', 'hsapiens', 'mmulatta', 'cjacchus', 'mmusculus', 'panubis', 'mdomestica', 'pabelii', 'sscrofa', 'oanatinus', 'ocuniculus', 'rnorvegicus', 'oaries', 'mgallopavo', 'csabaeus', 'tguttata', 'loculatus'
# Outgroups for 2R = 5: 'bfloridae', 'celegans', 'cintestinalis', 'csavignyi', 'dmelanogaster'
# Outgroups for 3R = 7: 'lchalumnae', 'loculatus', 'hsapiens', 'mmusculus', 'sscrofa', 'cfamiliaris', 'ggallus'

############ WGD for fish #############
my $wgdtype = '_2R';
# for tetrapods use '_2R' for fish '_2R' or '_3R'. DON'T LEAVE BLANK FOR THIS SCRIPT.

# CHANGE THE TOTAL OUTGROUPS $total_outgroups BELOW IF NEEDED ********
my $combineddir = '4_CombineWindows';

#--------------------------------------
my @allorgs = ('CARROT', 'TACGIG');

# For each organism ********************************************************************************************
foreach my $organism (@allorgs){ 

	# Decide wgd ----------------------
	my $wgd = ''; # for tetrapods
	my $total_outgroups = 2; # The number of outgroups to print proper column

	my $selfFile = $organism.'_Ohnologs_CombinedFromSelf_OneWay'."$wgd.txt";
	my $outgpFile = $organism.'_Ohnologs_CombinedFromAllOutgroups'."$wgd.txt";
	my $outfile = $organism.'Ohno_Self+Outgp'."$wgd.txt";

#if ($organism eq 'DYSSIL'){ # Test for 1 org

	print "Processing: $organism\n\nSelf: $selfFile\nOutgp: $outgpFile\nOutput: $outfile\nOutgroups: $total_outgroups\n\n";

	# ------------------------------------------------------------
	open SELF, "..\/$combineddir\/$organism\/$selfFile" or die $!;
	open OUTGP, "..\/$combineddir\/$organism\/$outgpFile" or die $!;
	open OUTFILE, ">$organism\/$outfile" or die $!;
	# ------------------------------------------------------------

	my @self = <SELF>;
	close (SELF);

	my %Self;
	foreach (@self){
	
		my @line = split "\t", $_;
		map {$_=~s/\n//g} @line;
	
		$Self{$line[0]}{$line[1]} = $line[4]; # Just a one way hash having p>=k
	}

	#print scalar keys %Self;

	# ------------------------------------------------------------
	my @outgroup = <OUTGP>;
	my $header = shift (@outgroup);
	$header =~s/\n//g;

	print OUTFILE "$header\tP-self(>=k)\n";

	my %OgPp;
	foreach (@outgroup){
	
		my @line = split "\t", $_;
		map {$_=~s/\n//g} @line;
	
		$OgPp{$line[0]}{$line[1]} = ''; 

	}
	close (OUTGP);
	# ------------------------------------------------------------


	foreach (@outgroup){
	
		my @line = split "\t", $_;
		map {$_=~s/\n//g} @line;
	
		# Check Hs-Hs hash
		if ((exists $Self{$line[0]}{$line[1]}) || (exists $Self{$line[1]}{$line[0]})){
		
			#print OUTFILE  "$line[0]\t$line[1]\t$line[2]\t$line[3]\t";
			print OUTFILE  join ("\t", @line), "\t";
			if (exists $Self{$line[0]}{$line[1]}){print OUTFILE  "$Self{$line[0]}{$line[1]}";}
			if (exists $Self{$line[1]}{$line[0]}){print OUTFILE  "$Self{$line[1]}{$line[0]}";}
		}
		else {
		
			#print OUTFILE  "$line[0]\t$line[1]\t$line[2]\t$line[3]\t";
			print OUTFILE  join ("\t", @line),"\t";
		}
		print OUTFILE  "\n";
	}
	# ------------------------------------------------------------

	foreach (@self){
	
		my @line = split "\t", $_;
		map {$_=~s/\n//g} @line;
	
		if ((not exists $OgPp{$line[0]}{$line[1]}) && (not exists $OgPp{$line[1]}{$line[0]})){
		
			print OUTFILE  "$line[0]\t$line[1]";
			for (my $i = 1; $i <= ($total_outgroups+3); $i++){
				print OUTFILE  "\t";
			}
			print OUTFILE  "$line[4]\n";
		}
	}
	# ------------------------------------------------------------

#} # end test for 1 org
} # End loop for each organism ********************************************************************************************



