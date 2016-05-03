#!/usr/bin/perl
use strict;
use warnings;
no warnings ('uninitialized','substr');
use feature qw(say);
########################################################################
#
# File      : alignment.pl

# Author    : Yatish
#
#########################################################################
#
#
# This program will take query sequence and mulitple sequence files as input and then print a alignment score.
##########################################################################
#

my $infile1 = 'multiplesequence.txt';
#unless (open(INFILE, "<", $infile) ){
#	die "Can't open ", $infile , " for reading " , $!;
#}

#$/ = ''; 
#my $sequence1 = <INFILE>;
#$/ = "\n";  

my $infile2 = 'querysequence.txt';
#unless (open(INFILE, "<", $infile) ){
#	die "Can't open ", $infile , " for reading " , $!;
#}

#$/ = ''; 
#my $sequence2 = <INFILE>;
#$/ = "\n";  
#close INFILE;

my @mulsequence = &parsefile($infile1);
my @querysequence = &parsefile($infile2);


my $size = @mulsequence;
my $ctr;
my $count = 0;
for (my $i=0;$i<$size;$i++){
my $elesize = length($mulsequence[$i]);
	$count =0;
	$ctr =0;
	say"ele size- ", $elesize;
	for(my $j=0; $j<$elesize; $j++){
	my $char1 = substr($mulsequence[$i],$j,1);
	my $char2 = substr($querysequence[0],$j,1);
	#say $char1;
	#say "\n",$char2;
	if ($char1 eq $char2){
	$count++;
	}else {
	$ctr++;
	}

}
say "\n","ctr- ",$ctr;
say "\n","count -", $count;
my $alignscore = $count/$elesize;
my $rounded = sprintf("%.2f", $alignscore);
say " Alignment score for $i sequence is ", $rounded, "\n";
}



sub parsefile(){
my ($infile) = @_;
my @seqarray;
unless (open (DATAFILE, "<", $infile)) {
	die " Can't open the file ", $infile, $!;
}

my $sequence = "";
my $start =1;

while (my $line = <DATAFILE>) {
chomp $line;
my $char = substr($line,0,1);
	if (!($char eq '>')) {
		$sequence=$sequence.$line;
	}
	else{
	if(!$start){
	push (@seqarray, $sequence);
	$sequence="";
	}
	elsif($start){
	$start = 0;
	}
}
}
push (@seqarray, $sequence);


return @seqarray;
close DATAFILE;
}
