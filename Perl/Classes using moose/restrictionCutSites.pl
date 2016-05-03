#! /usr/bin/perl
use warnings;
use strict;
use Getopt::Long;
use Pod::Usage;
use Carp qw( confess );
use feature qw(say);
use BioIO::SeqIO;
use BioIO::Seq;
use Data::Dumper;


########################################################################
## File   : restrictionCutSites.pl
## History:  Dec 8, 2015(Yatish) - Written the code structure and logic
##                  
#########################################################################
##
## 
########################################################################## 
## Sample execution line
## perl restrictionCutSites.pl -file p53_seq.txt
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
        $infile = "INPUT/p53_seq.txt";
}

my ( $begin, $end ) = ( 11717, 18680 ); # note: bio-friendly num
my $seqIoObj = BioIO::SeqIO->new(filename => $infile, fileType => 'fasta'); # object creation


# loop through all seqs in $seqIoObj
while ( my $seqObjLong = $seqIoObj->nextSeq() ) {
    my $seqObjShort = $seqObjLong->subSeq( $begin, $end );    # sub sequence
   
    # check if the coding seq is valid
    if( $seqObjShort->checkCoding()) {
    	print"The sequence starts with ATG codon and ends with a stop codon\n";
    }
    else{
       print "This is not a coding region"
    }
    
    # check the cutting sites
     my ($pos, $sequence) = $seqObjShort->checkCutSite( 'GGATCC' ); #BamH1
     if(!defined($pos)){
     	printFailedResult($seqObjShort,'BamH1')
     }else{
     printResults($pos, $sequence, $seqObjShort, 'BamH1'); # you should implement the printResults subroutine	
     }
     ($pos, $sequence) = $seqObjShort->checkCutSite( 'CGRYCG' ); #BsiEI
     if(!defined($pos)){
     	printFailedResult($seqObjShort,'BamH1')
     }else{
     	printResults($pos, $sequence, $seqObjShort, 'BsiEI');
     }
     ($pos, $sequence) = $seqObjShort->checkCutSite( 'GACNNNNNNGTC' );#DrdI 
     if(!defined($pos)){
     	printFailedResult($seqObjShort,'BamH1')
     }else{
     	printResults($pos, $sequence, $seqObjShort, 'DrdI');
     }
     
}

sub printResults{
	my ($pos,$seq,$seqObj,$re)=@_;
	my $filledUsage = 'Usage: ' . (caller(0))[3] . '($pos,$seq,$seqObj,$re)';
    @_ == 4 or confess getErrorString4WrongNumberArguments(), $filledUsage;
    
	say ("\nThe gene gi",$seqObj->gi(),": ");
	say ("Found ",$re," cut site at position ",$pos," of the coding region, here is the matched sequence ",$seq);
	
}

sub printFailedResult{
	my ($seqObj,$re)=@_;
	my $filledUsage = 'Usage: ' . (caller(0))[3] . '($seqObj,$re)';
    @_ == 2 or confess getErrorString4WrongNumberArguments(), $filledUsage;
    
	say ("\nThe gene gi",$seqObj->gi(),": ");
	say ($re,"was not found in the coding region");
}
