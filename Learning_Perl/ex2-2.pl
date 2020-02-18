#!/usr/bin/env perl

use 5.024;
use warnings;

print "Enter radius: ";
chomp (my $rad = <>);
my $pi = 3.141592654;
my $len = 2 * $pi * $rad;
say $len;
