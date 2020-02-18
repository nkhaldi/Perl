#!/usr/bin/env perl

use 5.024;
use warnings;

say "Enter 2 numbers:";
chomp (my $a = <>);
chomp (my $b = <>);
my $c = $a * $b;
say "$a * $b = $c"
