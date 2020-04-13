#!/usr/bin/env perl

# Измените предыдущую программу так, чтобы каждое
# вхождение Fred заменялось строкой Wilma,
# а каждое вхождение Wilma – строкой Fred.

use 5.018;
use warnings;

my $in = $ARGV[0];
die "Usage: $0 filename" unless defined $in;
my $out = $in;
$out =~ s/(\.\w+)?$/.out/;

die "Can't open '$in': $!" unless (open IN, "<$in");
die "Can't write '$out': $!" unless (open OUT, ">$out");

while (<IN>) {
    chomp;
    s/Fred/\n/gi;
    s/Wilma/Fred/gi;
    s/\n/Wilma/g;
    print OUT "$_\n";
}
