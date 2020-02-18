#!/usr/bin/env perl

use 5.024;
use warnings;

print "Enter radius: ";
chomp (my $rad = <>);

my $len = 0;
my $pi = 3.141592654;

if ($rad > 0) {
	$len = 2 * $pi * $rad;
}
say $len;
