#!/usr/bin/env perl

# Напишите пользовательскую функцию с именем total,
# которая возвращает сумму чисел в списке.

use 5.018;
use warnings;

sub total {
	my $sum = 0;
	for (@_) {
		$sum += $_;
	}
	return $sum;
}
