package Assignment5::Config;
use strict;
use warnings;

#use lib '/home/jain.ya/scripts/assignment5';
use Carp qw( confess );
use Exporter 'import';
our @EXPORT_OK = qw(getUnigeneDirectory);


sub getUnigeneDirectory{
        our $UNIGENE = '/data/PROGRAMMING/assignment5';
        return $UNIGENE;
}
1;