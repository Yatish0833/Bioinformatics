#! /usr/bin/perl
use warnings;
use strict;
use Getopt::Long;
use Pod::Usage;
use feature qw(say);
use Scalar::Util qw(looks_like_number);

########################################################################
# 
# File   :  DescriptiveStatistics.pl
# History:  Sep 20, 2015(Yatish) - Written the code structure and logic
#			Sep 22, 2015(Yatish) - Defensive programming
#           
########################################################################
#
# This program calculates the descriptive statistics of a given file. It
# takes to arguments as input file name and column number to find descriptive
# statistics on.
# Sample command for executing the program:
# perl DescriptiveStatistics.pl -file datafile3.txt -column 3
########################################################################

#variables declaration
my $file;
my $columnToParse;
my $fh;
my @data;
my @validData;

#Usage message
my $usage = "\n$0\n

     -file     file to open
     -column   Column number to analyse
     -help     Show this message
     Sample statement - perl DescriptiveStatistics.pl -file dataFile3.txt -column 3
";

#flags for the script
GetOptions(
   'file=s' => \$file,
   'column=i' => \$columnToParse,
    help => sub { pod2usage($usage); },
) or pod2usage(2);

#Checking if flags values are given as argument or not
unless ($file) {
    die "\n-file not defined\n$usage";
}
unless (defined($columnToParse)){
	die "\n - Column not defined \n $usage"
}


#Checking Whether file opens or not
unless (open ($fh, "<", $file) ){
    die "cant open '$file', $!";
}

# Reading the file storing only the column passed in the argument.
while(my $line = <$fh>){
    chomp $line;
    my @entireData = split( "\t",$line);
    push(@data,$entireData[$columnToParse])
}

#Count value
my $count = @data;



# Getting valid data in validData array
my $j=0;
for(my $i=0;$i<$count;$i++){
	if(!defined($data[$i])){
		die "There is no valid number in column ",$columnToParse,$!;
	}
	elsif($data[$i] !~ /NaN/i && $data[$i] !~ /INF/i && looks_like_number($data[$i])){
		$validData[$j]=$data[$i];
		$j++;
	}	
}

# Valid  numbers count
my $validNum = @validData;

# killing the script if there are no valid numbers to process
if($validNum == 0){
	die "There is no valid number in column ",$columnToParse,$!;
}

# subroutines to get average, max, min, variance and median
my $average = getAverage(@validData);
my ($max,$min) = getMaximumAndMinimum(@validData);
my $var = getVariance(@validData,$average);
my $stdDev = sqrt($var);
my $median = getMedian(@validData);

#subroutine to print the output
printOutput($count,$validNum,$average,$max,$min,$var,$stdDev,$median);



sub getAverage{
	my $count=0;
	my $sum=0;
	my $size=@validData;
	for(my $i=0;$i<$size;$i++){
		if(looks_like_number($validData[$i])){
			$sum+=$validData[$i];
		}
	}
	my $average = $sum/$size;
	return ($average);
}

sub getMaximumAndMinimum{
	my @sorted = sort { $a <=> $b } @validData;
	my $min = $sorted[0];
	my $max = $sorted[-1];
	return($max,$min);
}

sub getVariance{
	
	my $sumOfSquares = 0;
	my $value;
	my $n;
	my $variance;
	
	foreach $value (@validData){
		$n++;
		$sumOfSquares += ($average - $value) ** 2;		
	}
	if($n == 1){
		$variance = 0.000;
	}else{
		$variance = ( $sumOfSquares / ($n-1));
	}
	
	return ($variance);
}

sub getMedian{
	my @sorted = sort { $a <=> $b } @validData;
	my $med = 0;
	my $sum = 0;
	if (@sorted % 2 ==0){
		$sum = $sorted[(@sorted/2)-1] + $sorted[(@sorted/2)];
		$sum = $sum/2;
	}
	else{
		$sum = $sorted[@sorted/2];
	}
return ($sum);	
}

sub printOutput{
	
printf "\n\tColumn: %1.3f\n\n",$columnToParse;
printf "Count   \t = \t%1.3f\n",$count;
printf "ValidNum \t = \t%1.3f\n",$validNum;
printf "Average \t = \t%1.3f\n", $average;
printf "Maximum \t = \t%1.3f\n", $max;
printf "Minimum \t = \t%1.3f\n", $min;
printf "Variance \t = \t%1.3f\n", $var;
printf "Std Dev \t = \t%1.3f\n", $stdDev;
printf "Median  \t = \t%1.3f\n", $median;

}


close $fh;