#! /usr/bin/perl
use warnings;
use strict;
use Getopt::Long;
use Pod::Usage;
use Carp qw( confess );
use feature qw(say);
use BioIO::Kinases;
use BioIO::Config qw(getErrorString4WrongNumberArguments);
use BioIO::MyIO qw(getFh makeOutputDir);

use Data::Dumper;


########################################################################
## 
## File   : kinaseMap1.pl
## History:  Nov 22, 2015(Yatish) - Written the code structure and logic
##           #####Nov 4, 2015(Yatish) - Defensive programming and code documentation
##           
#########################################################################
##
## 
## 
## 
########################################################################## 
## Sample execution line
## 
#########################################################################


my $infile;
my $outfile;
#Usage message
my $usage = "\n$0 [options]\n

     -file     	Name of the input file
     -outfile	Name of the output file
     -help     	Show this message
     
";


#flags for the script
GetOptions(
   'file=s'	    => \$infile,
   'outfile=s'  => \$outfile,
    help => sub { pod2usage($usage); },
) or pod2usage(2);

if (!defined($infile)) {
        $infile = "kinases_map.txt";
        #die "\n Dying...Make sure to give a input file name\n",$usage;
}
if (!defined($outfile)) {
        $outfile = "output1_2.txt";
        #die "\n Dying...Make sure to give a input file name\n",$usage;
}

my $fhIn = getFh('<',$infile);
makeOutputDir("OUTPUT");
$outfile = "OUTPUT/".$outfile;
my $fhOut = getFh('>',$outfile);

my $kinaseObj = BioIO::Kinases->new($fhIn);

my $num = $kinaseObj->getElementInArray('name');
say Dumper(\$num);

my $kinaseObj2 = $kinaseObj->filterKinases( { name=>'tyrosine' } );
$kinaseObj2->printKinases($fhOut, ['symbol', 'name', 'location', 'omim_accession']);
say ($kinaseObj2->getNumberOfKinases());



=cut

$infile = "INPUT/".$infile; #reading the input file from INPUT folder so that user can just say the file name
my $fhIn = getFh('<',$infile);
makeOutputDir("OUTPUT");
$outfile = "OUTPUT/".$outfile; #writing the output file to OUTPUT folder so that user can just say the file name
my $fhOut = getFh('>',$outfile);

## This program prints only tyrosine kinase genes. It takes a input file
## of kinases map from OMIM database and prints the gene symbol, gene
## name, cytogenetic location and omim accession of the genes with 
## tyrosine kinase in gene names.
=cut
