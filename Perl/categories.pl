#! /usr/bin/perl
use warnings;
use strict;
use Getopt::Long;
use Pod::Usage;
use feature qw(say);
use MyIO qw(getFh);

########################################################################
# 
# File   :  categories.pl
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
my $file1;
my $file2;
my $outfile = "categories.txt";


#Usage message
my $usage = "\n$0 [options]\n

     -file1     open the chromosome 21 gene data (chr21_genes.txt)
     -file2		open the chromosome 21 gene category data (chr21_genes_categories.txt)
     -help      Show this message
";

#flags for the script
GetOptions(
   'file1=s' => \$file1,
   'file2=s'=> \$file2,
    help => sub { pod2usage($usage); },
) or pod2usage(2);

#Checking if flags values are given as argument or not
if (!defined($file1)) {
	$file1 = "chr21_genes.txt";
}
if (!defined($file2)) {
	$file2 = "chr21_genes_categories.txt";
}

#MAIN!
my $fhIn1 = getFh('<',$file1);
my $fhIn2 = getFh('<',$file2);
my $fhOut = getFh('>',$outfile);

my $refHashCategoryCount = getCategoryCount($fhIn1);
my $refHashCategoryMeaning = getCategoryMeaning($fhIn2);
printOutput($refHashCategoryCount,$refHashCategoryMeaning,$fhOut);





sub getCategoryCount{
	my ($fhIn) = @_;
	my %categoryCount;
	while(my $line = <$fhIn>){
		chomp $line;
    	my @columns = split(/\t/, $line);
    	if (!defined($columns[2]) || $columns[2] eq "Category"){
    		next;
    	}elsif (exists $categoryCount{$columns[2]}){
    		$categoryCount{$columns[2]}++;
    	}
    	else{
    		$categoryCount{$columns[2]} = 1;
    	}
	}	 
	
	return(\%categoryCount);
}


sub getCategoryMeaning{
	my ($fhIn) = @_;
	my %categoryMeaning;
	while(my $line = <$fhIn>){
		chomp $line;
    	my @columns = split(/\t/, $line);
    	$categoryMeaning{$columns[0]} = $columns[1];
	}

	return(\%categoryMeaning);
}


sub printOutput{
	my ($refHash1, $refHash2, $fh) = @_;
	say $fh ("Category","\t","Occurence","\t","Definition");
	foreach my $key (keys %$refHash2){
		$refHash1->{$key}.= "\t".$refHash2->{$key};
	}
		
	foreach my $key (sort {$a cmp $b} keys %$refHash1){
		say $fh ($key , "\t", $refHash1->{$key});
	}
}


