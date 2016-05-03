package BioIO::Config;
use strict;
use warnings;
use Carp qw( confess );
use Exporter 'import';
our @EXPORT_OK = qw(getErrorString4WrongNumberArguments);
use Readonly;

# an error string for subroutines in this module, and to export via the function:
# getErrorString4WrongNumberArguments
Readonly my $ERROR_STRING_BAD_NUM_ARGUMENTS  => "\nIncorrect number of arguments in call to subroutine. ";

=head1 NAME

BioIO::Config - package to show error message if any subroutine gets incorrect arguments

=head1 SYNOPSIS

Creation:

    use Config qw(getErrorString4WrongNumberArguments);


=head1 DESCRIPTION

This module was designed to be used by the Final programs, and to show 
error message if any subroutine gets incorrect arguments.

=head1 EXPORTS

=head2 Default behavior

Nothing by default. 

use Config qw( getErrorString4WrongNumberArguments );

=head1 FUNCTIONS

=head2 getErrorString4WrongNumberArguments

   Arg [1]    : No Arguments

   Example    : @_ == 1 or confess getErrorString4WrongNumberArguments() , $filledUsage;

   Description: This will return the error string defined by constant $ERROR_STRING_BAD_NUM_ARGUMENTS 
                One can use to get a generic string for error handling when the incorrect number of 
                parameters is called in a Module.

   Returntype : A scalar

   Status     : Stable

=cut
sub getErrorString4WrongNumberArguments{
    my $filledUsage = 'Usage: ' . (caller(0))[3] . '()';
    # test the number of arguments passed in were correct 
    @_ == 0 or confess $ERROR_STRING_BAD_NUM_ARGUMENTS , $filledUsage;
    return $ERROR_STRING_BAD_NUM_ARGUMENTS;
}


=head1 CONTACT

	jain.ya@husky.neu.edu


=cut
1;
