#! /usr/bin/perl
use warnings;
use strict;
use Getopt::Long;
use Pod::Usage;
use feature qw(say);

########################################################################
# 
# File   : pdbFastaSplitter .pl
# History:  Oct 3, 2015(Yatish) - Written the code structure and logic
#			Oct 5, 2015(Yatish) - Defensive programming
#           
########################################################################
# This program splits the pdb fasta file into two different files namely,
# pdbProtein.fasta and pdbSS.fasta.
# 
# Sample execution line
# perl pdbFastaSplitter.pl -infile ss.txt
########################################################################

#variables declaration
my $infile;
my $outfile1 = "pdbProtein.fasta";
my $outfile2 = "pdbSS.fasta";

#Usage message
my $usage = "\n$0 [options]\n

     -infile     Give a the fasta sequence file name to do the splitting, this file contains
              	 Two entries for each sequence, one with the protein sequence data, and one with 
              	 the SS information
     -help       Show this message
     
";

#flags for the script
GetOptions(
   'infile=s' => \$infile,
    help => sub { pod2usage($usage); },
) or pod2usage(2);

#Checking if flags values are given as argument or not
unless ($infile) {
    die "\n Dying...Make sure to give a file name of a sequence in FASTA format \n",$usage;
    
}
#function calls
my $fhIn = getFh('<',$infile);
my $fhOut1 = getFh('>',$outfile1);
my $fhOut2 = getFh('>',$outfile2);
my ($refArrHeader, $refArrSeqs) = getHeaderAndSequenceArrayRefs($fhIn);

#Printing the output
my $size = scalar @$refArrSeqs;
for(my $i=0; $i<$size;$i++){
	if($refArrHeader->[$i] =~ /(sequence)/){
		say $fhOut1 ($refArrHeader->[$i],"\n",$refArrSeqs -> [$i],"\n");
	}else{
		say $fhOut2 ($refArrHeader->[$i],"\n",$refArrSeqs -> [$i],"\n");
	}
}

#subroutines..
#########################################################################
# Scalar context: getFh($fhSign,$file)
#------------------------------------------------------------------------
# Takes the sign and file and returns the corresponding file handle
#########################################################################
sub getFh{
	my ($fhSign,$file) = @_;
	my $fh;
	if($fhSign eq '<'){
		unless (open ($fh, "<", $file) ){
    	die "cant open '$file' to read, $!";
		}
	}else{
		unless (open ($fh, ">", $file) ){
    	die "cant open '$file' to write, $!";
		}
	}
	return($fh);
}

#########################################################################
# List context: getHeaderAndSequenceArrayRefs($fhIn)
#------------------------------------------------------------------------
# Takes the reading file handle to read the file and returns the header
# and sequence array references
#########################################################################
sub getHeaderAndSequenceArrayRefs{
	my ($fh) = @_;
	my @header;
	my @seq;
	my $tmpSeq = "";
	while(my $line = <$fh>){
    chomp $line;
	if ($line =~ /^>+/) {
        push (@header,$line);
        if ($tmpSeq ne "") { 
          push (@seq, $tmpSeq);
          $tmpSeq = ""; 
        }
        
    }else {
    $tmpSeq .= $line; 
    $tmpSeq .= "\n";
    }
}
 if ($tmpSeq ne "") { 
          push (@seq, $tmpSeq);
          $tmpSeq = ""; 
        } 
_checkSizeOfArrayRefs(\@header,\@seq);

return(\@header,\@seq);
}

#########################################################################
# Void context: _checkSizeOfArrayRefs(\@header,\@seq) helper subroutine
#------------------------------------------------------------------------
# Takes the references to header and seqquence array and dies if the 
# sizes are not same and returns nothing if the sizes are same
#########################################################################

sub _checkSizeOfArrayRefs{
	my ($refArr1,$refArr2) = @_;
	my $sizeArr1 = scalar @$refArr1;
	my $sizeArr2 = scalar @$refArr2;
	if($sizeArr1 != $sizeArr2){
		print STDERR "many sequences were found for each of the output files";
		die;
	}else{
		return;
	}
}