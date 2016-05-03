#! /usr/bin/perl
use warnings;
use strict;
use Getopt::Long;
use Pod::Usage;
use Carp qw( confess );
use feature qw(say);
use BioIO::SeqIO;
use Data::Dumper;


########################################################################
## File   : genBank2Fasta.pl
## History:  Dec 8, 2015(Yatish) - Written the code structure and logic
##                  
#########################################################################
##
## 
########################################################################## 
## Sample execution line
## perl genBank2Fasta.pl -file genbank_seq.txt
#########################################################################


my $infile;
#Usage message
my $usage = "\n$0 [options]\n

     -file     	Name of the input file
     -help     	Show this message
     
";


#flags for the script
GetOptions(
   'file=s'	    => \$infile,
    help => sub { pod2usage($usage); },
) or pod2usage(2);

if (!defined($infile)) {
        $infile = "INPUT/genbank_seq.txt";
}


my $seqIoObj = BioIO::SeqIO->new(filename => $infile , fileType => 'genbank' ); # object creation

my $output = "OUTPUT";
# go thru SeqIO obj and print all seq
while (my $seqObj = $seqIoObj->nextSeq() ) {
   my $fileNameOut = $output . '/' . $seqObj->accn . ".fasta"; #create an output name
   $seqObj->writeFasta( $fileNameOut);    # write the Fasta File
}