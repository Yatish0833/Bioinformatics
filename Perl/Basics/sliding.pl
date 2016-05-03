#!/usr/bin/perl
use strict;
use warnings;
no warnings ('uninitialized', 'substr');
use feature qw(say);
########################################################################
#
# File      : sliding.pl
#
# Author    : Yatish
#
#########################################################################
#
#
# This program will take window size and sequence as argument from user and then will calculate GC content at each window size.
##########################################################################
#
#
my $windowSize = $ARGV[0];

if (! $windowSize){
        die "There is no window size given by user";
}
elsif ($windowSize == 0 || $windowSize <= 0){
	die "Window size cannot be zero or negative";
}

my $sequence = $ARGV[1];

if (! $sequence){
        die "There is no sequence given by user";
} elsif (($sequence)=~/[^ATGCatgc]/){
	die "Not a DNA sequence";
}

my $count =0;
my @seqArray;
my $len = length($sequence);

for (my $i =0;$i< $len; $i++){
$seqArray[$i]= substr($sequence,$i,1);
}
say $seqArray[2];

for(my $i=0;$i<$len;$i++){
	$count=0;
	for(my $j=$i; $j<($windowSize+$i); $j++){
	if (uc($seqArray[$j]) eq 'G' || uc($seqArray[$j]) eq 'C'){
	$count++;
	}
}
my $frequency = ($count/$windowSize);
say $i, "\t", $frequency, "\n";
} 
