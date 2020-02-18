#!/usr/bin/env perl

use 5.024;
use warnings;

chomp (my $str = <>);
chomp (my $n = <>);

while ($n--) {
	say $str;
}
