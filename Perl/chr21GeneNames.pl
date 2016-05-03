#! /usr/bin/perl
use warnings;
use strict;
use Getopt::Long;
use Pod::Usage;
use feature qw(say);
use MyIO qw(getFh);

########################################################################
# 
# File   : chr21GeneNames.pl
# History:  Oct 17, 2015(Yatish) - Written the code structure and logic
#			Oct 22, 2015(Yatish) - Defensive programming
#           
########################################################################
# This program takes a file as input, if absent runs on default file.
# Program ask user to input gene symbol and displays corresponding gene
# description. To exit user needs to type quit.
# 
# Sample execution line
# perl chr21GeneNames.pl -file chr21_genes.txt  
########################################################################

#variables declaration
my $file;

#Usage message
my $usage = "\n$0 [options]\n

     -file     open the chromosome 21 gene data (chr21_genes.txt)
     -help       Show this message
     
";

#flags for the script
GetOptions(
   'file=s' => \$file,
    help => sub { pod2usage($usage); },
) or pod2usage(2);

#Checking if flags values are given as argument or not
if (!defined($file)) {
	$file = "chr21_genes.txt";
}

my $fhIn = getFh('<',$file);

my $refHashFile = getHash($fhIn);

geneInputAndPrint($refHashFile);


#subroutines..
#########################################################################
# Scalar context: getHash($fhIn)
#------------------------------------------------------------------------
# Takes the file handle and returns the reference of hash containing
# gene symbol as key and corresponding description as value
#########################################################################

sub getHash{
	my ($fhIn) = @_;
	my %geneDescription;
	while(my $line = <$fhIn>){
    	chomp $line;
    	my @columns = split(/\t/, $line);
    	$geneDescription{$columns[0]} = $columns[1];
    }
    close $fhIn;
    %geneDescription = map {(uc $_, $geneDescription{$_})} keys %geneDescription;
    return(\%geneDescription);
}

#########################################################################
# Void context: geneInputAndPrint($refHashFile)
#------------------------------------------------------------------------
# Takes the reference to hash to ask the user for gene symbol input and
# displays corresponding description.
#########################################################################
sub geneInputAndPrint{
	my ($refHash) = @_;
	while(1){
		say "\nEnter the Gene Symbol for which you want to print Description (Type quit to exit): ";
		my $input = uc(<STDIN>);
		chomp $input;
		if($input eq "QUIT"){
			say "Thank you for querying the data. See you again. Thank You";
			last;
		}elsif(!exists($refHash->{$input})){
			say "Entered gene symbol is incorrect or doesn't exist in file. Please enter again.";
			next;
		}else{
			say $input," found! Here is the Description : \n",$refHash->{$input};
			next;
		}
	}
	
}