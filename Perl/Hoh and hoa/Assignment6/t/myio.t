#!/usr/bin/perl
use strict;
use warnings;
#use IO::Detect qw(is_filehandle);
use Test::More tests => 11;
use Test::Exception;


BEGIN { use_ok('Assignment5::MyIO', qw(getFh)) }


## create a file
my $goodFile = "goodNt_$$";
my $outFile1 = "outNt_$$";
my $outFile2 = "appendNt_$$";
createFile($goodFile);

## now further tests


my $fhInGood     = getFh("<", $goodFile);
my $fhOutGood1   = getFh(">", $outFile1);
my $fhOutGood2   = getFh(">>", $outFile2);

#use IO::Detect to test this, it's a better way

is(is_filehandle $fhInGood,   1, "is_filehandle passed");
is(is_filehandle $fhOutGood2, 1, "is_filehandle passed");
is(is_filehandle $fhOutGood1, 1, "is_filehandle passed");

#dies when too many arguments are given
dies_ok { getFh("<<", $fhInGood, 1) } 'dies ok when too many arguments are given';
#dies when not enough many arguments are given
dies_ok { getFh("<<") } 'dies ok when not enough arguments are given';
#dies when give it a bogus file name
dies_ok { getFh("<<", $fhInGood) } 'dies ok on <<';
#dies when no type of file to open is not given
dies_ok { getFh("", $fhInGood) } 'dies ok on no open type';
#dies when not filename is given
dies_ok { getFh("<", "") } 'dies ok on no file';
#dies when a director is given
dies_ok { getFh("<", "/home/cleslin/") } 'dies ok on a directory passed in';
#dies when no argument is given
dies_ok { getFh()} 'dies no argument given';

## clean up
unlink $goodFile;
unlink $outFile1;
unlink $outFile2;

sub createFile{
    my ($file) = @_;
    my $fhIn1;
    unless (open ($fhIn1, ">" , $file) ){
        die $!;
    }
    print $fhIn1 <<'_FILE_';
test
_FILE_
    close $fhIn1;
    return;
}
