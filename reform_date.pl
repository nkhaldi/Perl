#!/usr/bin/env perl

use 5.018;

my $date = <>;
if ($date =~ /(\d+)\-(\d+)\-(\d+)/) {
    say $3 . '.' , $2 , '.' , $1;
} else {
    say 'no';
}
