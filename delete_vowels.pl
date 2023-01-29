#!/usr/bin/env perl

use 5.012;


my %vowels = map { $_ => undef } qw( a e i o u y A E I O U Y );

for my $word (@ARGV) {
    my @letters = split(undef, $word);
    for my $letter (@letters) {
        print $letter unless exists $vowels{$letter};
    }
    print ' ';
}
print "\n"
