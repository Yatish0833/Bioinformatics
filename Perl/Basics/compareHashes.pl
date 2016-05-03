#!/usr/bin/perl
use strict;
use warnings;
use feature qw(say);
########################################################################
#
# File      : compareHashes.pl

# Author    : Yatish
#
#########################################################################
#
#
# This program will create a subroutine to compare hashes and check whether two hashes are equal or not.
##########################################################################
#

my %hash1 = ( ITALY => "ROME",
	      FRANCE =>"PARIS");
my %hash2 = (ITALY => "MILAN",
	     FRANCE => "PARIS");
my %hash3 = ( ITALY => "ROME");
my %hash4 = ( SPAIN => "ROME",
	      FRANCE => "PARIS");

compareHashes (\%hash1,\%hash1);
compareHashes (\%hash1,\%hash2);
compareHashes (\%hash1,\%hash3);
compareHashes (\%hash1,\%hash4);

sub compareHashes (){
	my ($refhash1,$refhash2) = @_;
	my %subhash1 = %$refhash1;
	my %subhash2 = %$refhash2;
	my $size1 = keys %$refhash1;
	my $size2 = keys %$refhash2;
my $ctr = 0;
my $ctrl = 0;
my $ctre = 0;

if($size1 == $size2){
	$ctr=1;
my (@arr1,@arr2);
my @arr = %$refhash1;
my $size = @arr;

my (@arr3, @arr4);
foreach my $key1 (sort keys %$refhash1){
for(my $i=0;$i<$size;$i++){
@arr1[$i] = $key1;
@arr3[$i] = $refhash1->{$key1};

}
}
foreach my $key2 (sort keys %$refhash2){
for(my $i=0;$i<$size;$i++){
@arr2[$i] = $key2;
@arr4[$i] = $refhash2->{$key2};
}
}	

for(my $i=0; $i<$size; $i++){
if (@arr1[$i] eq @arr2[$i]){
$ctrl=1;
}else {
$ctrl=0;
last;
}
}
#say "ctr for list", $ctrl;
for(my $i=0; $i<$size; $i++){
if (@arr3[$i] eq @arr4[$i]){
$ctre=1;
}else {
$ctre=0;
last;
}
}
#say "ctr for element", $ctre;
}
else {$ctr=0;}
#say"ctr for size", $ctr;
printhashes (\%subhash1,\%subhash2);
printcompare ($ctr,$ctrl,$ctre);
}

sub printhashes (){
	my ($refhash1,$refhash2) = @_;
say "\nThe first Hash \n";
foreach my $key1 (keys %$refhash1){
say "\n" ,$key1, "\t", $refhash1->{$key1};
}
say "\nThe second hash\n";
foreach my $key2 (keys %$refhash2){
say "\n" ,$key2, "\t", $refhash2->{$key2};
}
}
sub printcompare (){
	my ($ctr,$ctrl,$ctre) = @_;
#say"ctr", $ctr;
if($ctr == 1 && $ctrl == 1 && $ctre == 1 ){
say "\nTwo above hashes are equal\n";
}else{
say "\nTwo above hashes are not equal\n";
}
}	

