#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Banal::Utils' ) || print "Bail out!\n";
}

diag( "Testing Banal::Utils $Banal::Utils::VERSION, Perl $], $^X" );
