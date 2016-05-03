#! /usr/bin/perl
use warnings;
use strict;
use Getopt::Long;
use Pod::Usage;
use feature qw(say);
use MyIO qw(getFh);

########################################################################
# 
# File   :  intersection.pl
# History:  Oct 17, 2015(Yatish) - Written the code structure and logic
#			Oct 22, 2015(Yatish) - Defensive programming
#           
########################################################################
# This program takes two files as input, if absent runs on default files.
# It will find the common gene symbol occurences in both the files and
# prints the count to terminal and names in output file in alphabetical
# order
# 
# Sample execution line
# perl intersection.pl -file1 chr21_genes.txt -file2 HUGO_genes.txt  
########################################################################


#variables declaration
my $file1;
my $file2;
my $outfile = "intersectionOutput.txt";


#Usage message
my $usage = "\n$0 [options]\n

     -file1     open the chromosome 21 gene data (chr21_genes.txt)
     -file2		open the HUGO gene data (HUGO_genes.txt)
     -help      Show this message
";

#flags for the script
GetOptions(
   'file1=s' => \$file1,
   'file2=s'=> \$file2,
    help => sub { pod2usage($usage); },
) or pod2usage(2);

#Checking if flags values are given as argument or not if not run the program with default value
if (!defined($file1)) {
	$file1 = "chr21_genes.txt";
}
if (!defined($file2)) {
	$file2 = "HUGO_genes.txt";
}


#MAIN!
my $fhIn1 = getFh('<',$file1);
my $fhIn2 = getFh('<',$file2);
my $fhOut = getFh('>',$outfile);


my $refArrChr21 = getArray($fhIn1);
my $refArrHugo = getArray($fhIn2);

my $refArrIntersection = getIntersection($refArrChr21,$refArrHugo);
printIntersection($refArrIntersection,$fhOut);

#subroutines..
#########################################################################
# Scalar context: getArray($fhIn1)
#------------------------------------------------------------------------
# Takes the file handle and returns the reference of array containing
# gene symbol 
#########################################################################
sub getArray{
	my ($fh) = @_;
	my @geneData;
	while(my $line = <$fh>){
		chomp $line;
    	my @columns = split(/\t/, $line);
    	push @geneData, $columns[0];
	}
	my @genes = map(uc,@geneData);
	
	return(\@genes);
}

#########################################################################
# Scalar context: getIntersection($refArrChr21,$refArrHugo)
#------------------------------------------------------------------------
# Takes two arrays reference as input and returns the reference of 
# intersection array found by using temporary hash 
#########################################################################
sub getIntersection{
	my ($refArr1, $refArr2) = @_;
	my %second = map {$_=>1} @$refArr1;
	my @intersection= grep { $second{$_} } @$refArr2;
	return (\@intersection);
}

#########################################################################
# Void context: printIntersection($refArrIntersection,$fhOut)
#------------------------------------------------------------------------
# Takes the reference to array and file handle to print the intersection
# array to output file and count to terminal.
#########################################################################
sub printIntersection{
	my ($refArr,$fh) = @_;
	my $len = scalar @$refArr;
	say "Number of common gene symbols found are: ",$len;
	
	for(my $i=0; $i<$len;$i++){
		say $fh ($refArr->[$i]);	
	}
	
}