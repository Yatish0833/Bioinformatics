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
        $outfile = "output1_1.txt";
        #die "\n Dying...Make sure to give a input file name\n",$usage;
}

my $fhIn = getFh('<',$infile);
makeOutputDir("OUTPUT");
$outfile = "OUTPUT/".$outfile;
my $fhOut = getFh('>',$outfile);

my $kinaseObj = BioIO::Kinases->new($fhIn);
#say Dumper(\$kinaseObj);
$kinaseObj->printKinases($fhOut, ['symbol','name','location'] );


my $aoh = $kinaseObj->getAoh();
say ref($kinaseObj);

my $hash=$kinaseObj->getElementInArray('na');
say $hash;