#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 2;
use Test::Exception;#need this to get dies_ok and lives_ok to work


BEGIN { use_ok('Assignment4::Config', qw(getErrorString4WrongNumberArguments)) }
#dies when give it a bogus file name
dies_ok { getErrorString4WrongNumberArguments(1) } 'dies ok when an argument is passed';