package Assignment5::MyIO;
use warnings;
use strict;
use feature qw(say);
use Exporter 'import';
our @EXPORT_OK = qw(getFh);

sub getFh{
	my ($type, $file) = @_;
    my $fh;  # create a filehandle
    if ($type ne '>' && $type ne '>>' && $type ne '<'){
        die "Can't use thie type for opening '" , $type , "'";
    }
    if (-d $file){ # if what was sent in was a direcotry, die
        die "\nDying... The file you provided is a directory";
    }
    unless (open($fh,  $type , $file) ) {
        die "Can't open " , $file , " for reading/writing/appending: " , $!;
    }
    return ($fh);
}

1;