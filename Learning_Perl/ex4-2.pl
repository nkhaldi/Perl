#!/usr/bin/env perl

# Используя функцию из предыдущего упражнения, напишите
# программу для вычисления суммы чисел от 1 до 1000.

use 5.018;
use warnings;

sub total {
	my $sum = 0;
	for (@_) {
		$sum += $_;
	}
	return $sum;
}

my @list = (1..1000);
say total(@list);
