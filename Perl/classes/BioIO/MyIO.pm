package BioIO::MyIO;
use warnings;
use strict;
use feature qw(say);
use Exporter 'import';
use Carp qw( confess );
use File::Path qw(make_path);
#use lib '/Users/Yatish/Desktop/Fall\ 2015/Programming/codes/assignment7';
#use BioIO::Config qw(getErrorString4WrongNumberArguments);
our @EXPORT_OK = qw(getFh makeOutputDir);

=head1 NAME

BioIO::MyIO - package to handle opening of files and passing filehandles

=head1 SYNOPSIS

Creation:
        use BioIO::MyIO qw(getFh makeOutputDir);
        my $infile = "kinases_map.txt";
        my $fhIn = getFh('<',$infile);

=head1 Description

This module is designed to be used by Assignment 7 programs to get a filehandle
for a file for reading, writing or appending.

=head1 EXPORTS

=head2 Default Behavior

        Nothing by default.
        use BioIO::MyIO qw(getFh makeOutputDir);

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
        
=head2 makeOutputDir

   Arg [1]    : A directory name that needs to be created

   Example    : makeOutputDir( 'assignment_output' );

   Description: This function will make the directory passed if it does not exist if you have privileges

   Returntype : undef

   Status     : Stable
   
=cut

sub getFh{
        my ($type, $file) = @_;
        my $filledUsage = 'Usage: ' . (caller(0))[3] . '($type, $file)';
        @_ ==2 or confess getErrorString4WrongNumberArguments(), $filledUsage;

        my $fh;  # create a filehandle
        if ($type ne '>' && $type ne '>>' && $type ne '<'){
                confess "Can't use this type for opening '" , $type , "'";
        }
        if (-d $file){ # if what was sent in was a direcotry, die
                confess "\nDying... The file you provided is a directory";
        }
        unless (open($fh,  $type , $file) ) {
                confess "Can't open " , $file , " for reading/writing/appending: " , $!;
        }
        return ($fh);
}

sub makeOutputDir{
	my($dir)= @_;
	my $filledUsage = 'Usage: ' . (caller(0))[3] . '($dir)';
    @_ ==1 or confess getErrorString4WrongNumberArguments(), $filledUsage;
	
	if(!(-d $dir)){
		make_path($dir);
	}
	
}

=head1 CONTACT

        jain.ya@husky.neu.edu

=cut



1;

