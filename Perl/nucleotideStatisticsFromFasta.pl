#! /usr/bin/perl
use warnings;
use strict;
use Getopt::Long;
use Pod::Usage;
use feature qw(say);

########################################################################
# 
# File   : nucleotideStatisticsFromFasta.pl
# History:  Oct 3, 2015(Yatish) - Written the code structure and logic
#			Oct 5, 2015(Yatish) - Defensive programming
#           
########################################################################
# This program reads the infile and the name of the outfile and writes
# the nucleotide statistics to the outfile
######################################################################## 
# Sample execution line
# perl nucleotideStatisticsFromFasta.pl -infile influenza.fasta -outfile influenza.stats.txt
########################################################################

#variables declaration
my $infile;
my $outfile;


#Usage message
my $usage = "\n$0 [options]\n

     -infile    Give a fasta sequence file name to do the stats on
     -outfile	Provide a output file to put the stats into
     -help      Show this message
";

#flags for the script
GetOptions(
   'infile=s' => \$infile,
   'outfile=s'=> \$outfile,
    help => sub { pod2usage($usage); },
) or pod2usage(2);

#Checking if flags values are given as argument or not
unless ($infile) {
    die "\n Dying...Make sure to give a file name of a sequence in FASTA format\n",$usage;
}
unless ($outfile) {
    die "\n Dying...Make sure to give an outfile name for the stats\n",$usage;
}

#MAIN!
my $fhIn = getFh('<',$infile);
my $fhOut = getFh('>',$outfile);

my ($refArrHeader, $refArrSeqs) = getHeaderAndSequenceArrayRefs($fhIn);
printSequenceStats($refArrHeader, $refArrSeqs,$fhOut);



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
        
    }
    else {
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

#########################################################################
# Void context: printSequenceStats($refArrHeader, $refArrSeqs,$fhOut) 
#------------------------------------------------------------------------
# Takes the references to header and seq array and file handle for output
# and prints ount the statistics of every sequences to output file. This
# subroutine also calls two helper subroutines _getNtOccurrence and
# _getAccession
#########################################################################
sub printSequenceStats{
	my ($refArrH,$refArrS,$fileOut) = @_;
	my $size = scalar @$refArrS;
	say $fileOut ("Number\tAccession\tA's\tG's\tC's\tT's\tN's\tLength\tGC%");
	for(my $i=0; $i<$size;$i++){
		my $seq = $refArrS->[$i];
		my $header = $refArrH->[$i];
		my $A = _getNtOccurrence('A', \$seq);
		my $C = _getNtOccurrence('C', \$seq);
		my $G = _getNtOccurrence('G', \$seq);
		my $T = _getNtOccurrence('T', \$seq);
		my $N = _getNtOccurrence('N', \$seq);
		my $acc = _getAccession($header);
		my $length = length($seq);
		my $gc = (($G+$C)/($length))*100;
		#Print output here
		say $fileOut ($i+1,"\t",$acc,"\t",$A,"\t",$G,"\t",$C,"\t",$T,"\t",$N,"\t",$length,"\t",$gc,"\n");
}
}

#########################################################################
# Scalar context: _getNtOccurrence($base,$dna) helper subroutine
#------------------------------------------------------------------------
# Takes in the character and sequence scalar refence and calculate the 
# number of occurences of this character in sequence and returns it.
#########################################################################

sub _getNtOccurrence{
	my ($base,$dna) = @_;
	#say $$dna;
	my $nt;
	my $count =0;
	my $len = length($$dna);
	for(my $i=0;$i<$len;$i++){
		$nt= substr($$dna,$i,1);
		if($nt eq $base){
			$count++;
		}else{}
	}
	return($count);
}

#########################################################################
# Scalar context: _getAccession($header) helper subroutine
#------------------------------------------------------------------------
# Takes in header in scalar context and returns the accession number.
#########################################################################

sub _getAccession{
	my ($head) = @_;
	my $accession;
	if($head =~ /^>(\w+)\s+/){
		$accession = $1;
	}else{}
	return($accession);
}