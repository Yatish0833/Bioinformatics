#! /usr/bin/perl
use warnings;
use strict;
use Getopt::Long;
use Pod::Usage;
use Carp qw( croak );
use feature qw(say);
use Assignment6::Config qw(getErrorString4WrongNumberArguments);
use Assignment6::MyIO qw(getFh);
use Data::Dumper;


########################################################################
## 
## File   : snpScan.pl
## History:  Nov 11, 2015(Yatish) - Written the code structure and logic
##           #####Nov 4, 2015(Yatish) - Defensive programming and code documentation
##           
#########################################################################
## This program takes three input input file, eQTL file and output file name.
## Program looks for the nearest position of chr of input file in eQTL file
## and give the detail if the nearest find. 
## 
########################################################################## 
## Sample execution line
## perl snpScan.pl -query input.txt -eqtl affy6.dat -outfile output.txt
#########################################################################

##variables declaration
my $query;
my $eqtl;
my $output;

#Usage message
my $usage = "\n$0 [options]\n

     -query     Name of the input file
     -eqtl      Name of the eqtl file
     -output	Name of the output file
     -help     Show this message
     
";


#flags for the script
GetOptions(
   'query=s'	 => \$query,
   'eqtl=s' 	 => \$eqtl,
   'output=s'	 => \$output,
    help => sub { pod2usage($usage); },
) or pod2usage(2);


if (!defined($query)) {
        $query = "input.txt";
        #die "\n Dying...Make sure to give a input file name\n",$usage;
}

if (!defined($eqtl)) {
        $eqtl = "affy6.dat";
        #die "\n Dying...Make sure to give a eqtl file name\n",$usage;
}
if (!defined($output)) {
        $output = "output.txt";
        #die "\n Dying...Make sure to give a output file name\n",$usage;
}


my $refHoAInput = getQuerySites($query);
my ($refHoAEqtl,$refHoHEqtl) = getEqtlSites($eqtl);
compareInputSitesWithQtlSites($refHoAInput,$refHoAEqtl,$refHoHEqtl,$output);



sub getQuerySites{
	my ($infile) = @_;
	my $filledUsage = 'Usage: ' . (caller(0))[3] . '($infile)';
    @_ == 1 or croak getErrorString4WrongNumberArguments(), $filledUsage;
	
	my $fhIn = getFh('<',$infile);
	my %HoA;
	
	while(my $line = <$fhIn>){
    	chomp $line;
    	next if $. < 2;
    	
		my ($chr,$start,$end) = split /\t/ , $line;
		
		push @{$HoA{$chr}} , $end;
		
	}
	return(\%HoA); 
}            

sub getEqtlSites{
	my ($infile) = @_;
	my $filledUsage = 'Usage: ' . (caller(0))[3] . '($infile)';
    @_ == 1 or croak getErrorString4WrongNumberArguments(), $filledUsage;
	
	my $fhIn = getFh('<',$infile);
	my (%HoA,%HoH);
	
	while(my $line = <$fhIn>){
		chomp $line;
		next if $. < 2;
		
		my($rsnum,$host_func,$flankGenes,$expression) = split /\t/,$line;
		my @hostFunc = split /:/,$host_func;
		
		push @{$HoA{$hostFunc[2]}} ,$hostFunc[3];
		
		$HoH{$hostFunc[2]} -> {$hostFunc[3]} = $expression;
		
	}
	print Dumper(\%HoH);
	return(\%HoA,\%HoH);
}


sub compareInputSitesWithQtlSites{
	my ($refHoAInput,$refHoAEqtl,$refHoHEqtl,$output) = @_;
	my $filledUsage = 'Usage: ' . (caller(0))[3] . '($refHoAInput,$refHoAEqtl,$refHoHEqtl,$output)';
    @_ == 4 or croak getErrorString4WrongNumberArguments(), $filledUsage;
	
	my $fhIn = getFh('>',$output);
	say $fhIn "#Site\tDistance\teQTL\t[Gene:P-val:Population]";
	foreach my $chr (sort {$a<=>$b} (keys %$refHoAInput)){
		#next unless (exists($refHoAEqtl->{$chr}) || defined($refHoAInput->{$chr}));
		foreach my $pos (sort {$a<=>$b} (@{$refHoAInput->{$chr}})){
			if(defined($pos)){
				if(my $nearestPosition = _findNearest($chr, $pos, $refHoAEqtl)){
				say  $chr,":",$pos,"\t",abs($pos-$nearestPosition),"\t",$chr,":",$nearestPosition,"\t",$refHoHEqtl->{$chr}->{$nearestPosition};
				
				}else{
					warn "Cannot find requested chromosome position in data " , 
			          "chr = " , $chr , " position = " , $pos; 
				}
			}
		}
	}
}

sub _findNearest{
	my ($chr,$pos,$refHoAEqtl) = @_;
	my $filledUsage = 'Usage: ' . (caller(0))[3] . '($chr,$pos,$refHoAEqtl)';
    @_ == 3 or croak getErrorString4WrongNumberArguments(), $filledUsage;
	
	
	my $diff;
	my $result;
	foreach my $position (@{$refHoAEqtl->{$chr}}){
		if(!defined($diff) || abs($pos-$position) < $diff){
			$diff = abs($pos-$position);
			$result = $position;
		}elsif( abs($pos-$position)== $diff){
			$result=$position;
		}
	}
	if(defined($result)){
                return $result;
        }else{
                return;
        }
}
