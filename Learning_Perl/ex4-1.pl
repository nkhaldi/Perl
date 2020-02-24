#!/usr/bin/env perl

# Напишите пользовательскую функцию с именем total,
# которая возвращает сумму чисел в списке.

use 5.024;

sub total {
	my $sum = 0;
	for (@_) {
		$sum += $_;
	}
	return $sum;
}
