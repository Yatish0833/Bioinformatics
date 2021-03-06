package Assignment6::MyIO;
use warnings;
use strict;
use feature qw(say);
use Exporter 'import';
use Carp qw( croak );
our @EXPORT_OK = qw(getFh);

=head1 NAME

Assignment6::MyIO - package to handle opening of files and passing filehandles

=head1 SYNOPSIS

Creation:
        use Assignment6::MyIO qw(getFh);
        my $infile = "affy6.dat";
        my $fhIn = getFh('<',$infile);

=head1 Description

This module is designed to be used by Assignment 6 programs to get a filehandle
for a file for reading, writing or appending.

=head1 EXPORTS

=head2 Default Behavior

        Nothing by default.
        use Assignment5::MyIO qw(getFh);

=head1 FUNCTIONS

=head2 getFh

        Arg [0]    : Type of file to open, reading '<', writing '>', appending '>>'
        Arg [1]    : Name of file to open
        Example    : my $fh = getFh('<', $infile);

        Description: This will return a filehandle to the file passed in.  This function
                     can be used to open, write, and append, and get the File Handle. You are 
                     best giving the absolute path, but since we are using this Module in the same directory 
                     as the calling scripts, we are fine.
        Returntype : A filehandle

        Status     : Stable
=cut

sub getFh{
        my ($type, $file) = @_;
        my $filledUsage = 'Usage: ' . (caller(0))[3] . '($type, $file)';
        @_ ==2 or croak " incorrect number of arguments ", $filledUsage;

        my $fh;  # create a filehandle
        if ($type ne '>' && $type ne '>>' && $type ne '<'){
                croak "Can't use this type for opening '" , $type , "'";
        }
        if (-d $file){ # if what was sent in was a direcotry, die
                croak "\nDying... The file you provided is a directory";
        }
        unless (open($fh,  $type , $file) ) {
                croak "Can't open " , $file , " for reading/writing/appending: " , $!;
        }
        return ($fh);
}

=head1 CONTACT

        jain.ya@husky.neu.edu

=cut



1;