#! /usr/bin/perl
use warnings;
use strict;
use Getopt::Long;
use Pod::Usage;
use List::MoreUtils qw(any);
use feature qw(say);
use Assignment5::Config qw(getUnigeneDirectory);
use Assignment5::MyIO qw(getFh);

########################################################################
## 
## File   : getGeneInfo.pl
## History:  Nov 2, 2015(Yatish) - Written the code structure and logic
##           Nov 4, 2015(Yatish) - Defensive programming and code documentation
##           
#########################################################################
## This program takes hosts name and gene name as input, if absent runs on default file.
## Program checks if the directory exist for this organism and gene, if it
## exist programs tells the organs where this gene is expressed.
## 
########################################################################## 
## Sample execution line
## perl getGeneInfo.pl -host Humans -gene TGM1
#########################################################################


##variables declaration
my $host;
my $gene;

#Usage message
my $usage = "\n$0 [options]\n

     -host     Name of the host in which you want the tissue in which gene of the interest is expressing
     -gene     Gene of interest
     -help     Show this message
     
";

#flags for the script
GetOptions(
   'host=s' => \$host,
   'gene=s' => \$gene,
    help => sub { pod2usage($usage); },
) or pod2usage(2);

if (!defined($host)) {
        $host = "Homo_sapiens";
}

if (!defined($gene)) {
        $gene = "TGM1";
}

# Hash of array datastructure to test the list of common names and scientific name
my %hashOfHosts = (     'Homo_sapiens'      => [ 'homo sapiens' , 'human' , 'humans' ],
                        'Bos_taurus'        => [ 'bos taurus' , 'cow' , 'cows'],
                        'Equus_caballus'    => [ 'equus caballus' , 'horse' , 'horses'],
                        'Mus_musculus'      => [ 'mus musculus' , 'mouse' , 'mice'],
                        'Ovis_aries'        => [ 'ovis aries' , 'sheep' , 'sheeps'],
                        'Rattus_norvegicus' => [ 'rattus norvegicus' , 'rat' , 'rats']
                     );

#### Check for different hosts name and convert different hosts name to scientific name
#Print error message if hosts doesn't exist.
if(any {lc($_) eq lc($host)} keys %hashOfHosts){
        ($host) = grep{ lc($_) eq lc($host)} keys %hashOfHosts;
}elsif((grep { grep { $_ eq lc($host) } @{$hashOfHosts{$_}} } keys %hashOfHosts) == 1){
        ($host) = grep { grep { $_ eq lc($host) } @{$hashOfHosts{$_}} } keys %hashOfHosts;
}else{
        printHostDirectoriesWhichExist();
        exit;
}

#Check if the gene mentioned in the argument is valid or not
if ( isValidGeneName($gene, $host) ){
   print "\nFound Gene $gene for $host\n";
}
else{
   print "\nThis Gene $gene does not exists for $host, exiting now\n";
   exit;
}

#Checked both organism and gene. Lets open the file now!
my $refTissueArray = getGeneData($gene,$host);
printOutput($refTissueArray,$gene,$host);




#subroutines..
#########################################################################
# Void context: printHostDirectoriesWhichExist()
#------------------------------------------------------------------------
# This subroutine is called in a void context when we match that the
# given host name doesnot exist in directory
#########################################################################

sub printHostDirectoriesWhichExist{
        say "\nEither the Host Name you are searching for is not in the database \n";
        say "or If you are trying to use the scientific name please put the name in double quotes: \n";
        say "\"Scientific name\"\n";
        say "\nHere is a (non-case sensitive) list of available Hosts by scientific name \n";
        say "1. Homo_sapiens";
        say "2. Bos_taurus";
        say "3. Equus_caballus";
        say "4. Mus_musculus";
        say "5. Ovis_aries";
        say "6. Rattus_norvegicus";
        
        say "\nHere is a (non-case sensitive) list of available Hosts by common name\n";
        say "1. Human";
        say "2. Cow";
        say "3. Horse";
        say "4. Mouse";
        say "5. Sheep";
        say "6. Rat";
}


#########################################################################
# Boolean context: isValidGeneName($gene, $host)
#------------------------------------------------------------------------
# Takes gene name and host name as argument and check whether the gene 
# file exist or not return true if it exists else return false.
#########################################################################
sub isValidGeneName{
        my ($geneName,$org) = @_;
        my $infile = getUnigeneDirectory(). '/' . $org . '/' . $geneName . '.unigene';
        if(-e $infile){
                return 1;
        }else{
                return;
        }
}

#########################################################################
# Scalar context: getGeneData($gene,$host)
#------------------------------------------------------------------------
# Takes gene name and host name as argument and read the gene file to
# capture the list of organs where this gene is expressed. This list is
# stored in array and reference of sorted array is then returned.
#########################################################################
sub getGeneData{
        my ($geneName,$org) = @_;
        my $infile = getUnigeneDirectory(). '/' . $org . '/' . $geneName . '.unigene';
        my $fhIn = getFh('<',$infile);
        my (@tissue,$tissues);
        while(my $line = <$fhIn>){
                chomp $line;
                if($line =~ /^EXPRESS\s+(.*)/){
                        $tissues=$1;
                }
        }
        @tissue = split(/\|\s?/,$tissues);
        my @sortedTissue = sort(@tissue);

        return(\@sortedTissue);
}


#########################################################################
# Void context: printOutput($refTissueArray,$gene,$host);
#------------------------------------------------------------------------
# Takes reference to sorted array gene name and host name as argument and 
# prints the name of tissues where the gene is expressed.
#########################################################################
sub printOutput{
        my($refArr,$geneName,$org)=@_;
        my $size= scalar @$refArr;
        say "In $org, There are $size tissues that $geneName is expressed in: \n";
        my $i=1;
        foreach my $ele (@$refArr){
                printf "%3d. %s\n",$i,$ele;
                $i++;
        }
}
                      