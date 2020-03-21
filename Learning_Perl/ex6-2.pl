#!/usr/bin/env perl

# Напишите программу, которая читает серию слов,
# а затем выводит сводку с количеством вхождений каждого слова.
# Чтобы задание стало более интересным, отсортируйте сводку по ASCIIQкодам.

use 5.018;
use warnings;

my %count;
chomp (my @words = <>);

for my $word (@words) {
	$count{$word}++;
}

for my $word (sort keys %count) {
	say "$word - $count{$word}";
}
