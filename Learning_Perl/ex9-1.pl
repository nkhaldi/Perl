#!/usr/bin/env perl

# Создайте шаблон, который совпадает с тремя
# последовательными копиями текущего содержимого $what.

use 5.018;
use warnings;

chomp (my $what = <STDIN>);

while (<>) {
	chomp;
	if (/($what){3}/) {
		say;
	}
}
