#!/usr/bin/perl
use strict;
use warnings;
no warnings ('uninitialized', 'substr');
use feature qw(say);
########################################################################
#
# File      : compareFiles.pl
#
# Author    : Yatish
#
#########################################################################
#
#
# This program will compare two text file to find uniprot accession number of interest.
##########################################################################
#

my $infile = 'affymetrixIDs_MouseToUniProtAccessions.txt';
unless (open(INFILE1, "<", $infile) ){
	die "Can't open ", $infile , " for reading " , $!;
}
$/ = ''; 
my $affymetricID = <INFILE1>;
$/ = "\n";
close INFILE1;
my $infile2 = 'geneIDs3_MouseToUniProtAccessions.txt';
unless (open(INFILE2, "<", $infile2) ){
	die "Can't open ", $infile2 , " for reading " , $!;
}
$/ = ''; 
my $geneID= <INFILE2>;
$/ = "\n";
close INFILE2;
my %genehash;
#my $i=0;
my $ctr =0;
while ($geneID=~/^(\w+)\s+(\S+)/mg){
$genehash{$2} = 1;
$ctr++;
#$i++;
}
say $ctr;
#say $i;
my $count =0;
#my $j=0;
while ($affymetricID=~/^(\w+)\s+(\S+)/mg){
	if (exists $genehash {$2}){
	say $2, "\n";
	$count++;
}

}

say $count;
=cut
for (my $i=1;$i<$size;$i++){

	for (my $j=1;$j<$size1;$j++){
	if($geneArray[$i] eq $affArray[$j]){
	$resultArray[$i] = $geneArray[$i];
	}
}
}
my $size2=@resultArray;
say "Common Mus musculus UNIPROT_ACCESIONs of interest are as follows";
for (my $i=0;$i<$size2; $i++){

say "\t", $resultArray[$i], "\n";

}


