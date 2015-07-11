#!usr/bin/perl -w
use strict;
use List::Util qw[sum];
use constant WINDOW => 10;

###########################################
###	makes mean Fst in stepping window 	###
###	INPUT: vcftools Fst output			###
###########################################





my $fstinput = $ARGV[0];

open(INPUT, $fstinput) || die "cannot open fst input file";
open(OUTPUT,">window_fst_mean.txt")|| die "cannot open output file";

my @data;
my $counter = 0;

while(my $line = <INPUT>){
	if($counter != 0){
		my @temp = split(/\t/,$line);
		my $chromosome = $temp[0];
		my $position = $temp[1];
		my $fst = $temp[2];
		chomp($fst);
		push (@data, $fst);
	}
	$counter++;
}


my $windowStart = 0; # stores start of window
my @mean;
print "\n\noriginal data: @data\n";



while ($windowStart <= @data - WINDOW) {
	# use while loop to hop through the array
	# each iteration of the loop points to the start position of the window
	# loop will run unitl we are a WINDOW size less than the length of the array
	
	my $windowEnd = ($windowStart + WINDOW) - 1;  #calculate window end position by adding window size minus 1
	
	my @dataWindow = @data[$windowStart..$windowEnd]; # get a subset of the array based on the window start and end values 

	my $windowAverage = sum (@dataWindow) / WINDOW ; #calculat average
	push @mean, $windowAverage; #save the average
	print OUTPUT "$windowAverage\n";
	print "average of window [@dataWindow] (elements $windowStart to $windowEnd) is $windowAverage\n";

	$windowStart = $windowStart + WINDOW;	# work out the next window start position by adding the window size
}

#print "\n\nwindowed averages @mean\n";
print "window size: ", WINDOW,"\n";
