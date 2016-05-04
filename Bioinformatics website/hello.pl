#!c:/perl/bin -w
use strict;
use CGI;

my $q = new CGI;

my $path_to_program = "/Users/Yatish/Documents/Bioinformatics\ website/hello.pl";
my $return_value = system("perl",$path_to_program);

# this is the actual execution of the script. 
# now you can put a message to the user
print $q->header; # send correct header, text/html
# put HTML h
