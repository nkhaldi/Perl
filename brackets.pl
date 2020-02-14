#!/usr/bin/env perl

#	Программа проверяющая правильность расстановки скобок в строке

use 5.024;
use warnings;

my $el = 0;
my @stack = ();
chomp (my $input = <>);
my @brackets = split //, $input;

sub get_pair {
	my $brac = shift;

	if ($brac eq ')') {
		return '(';
	} elsif ($brac eq ']') {
		return '[';
	} elsif ($brac eq '}') {
		return '{';
	} elsif ($brac eq '>') {
		return '<';
	}
	return 0;
}

while (@brackets) {
	$_ = shift @brackets;
	if (/\[|\(|\{|\</) {
		push @stack, $_;
	} elsif (/\)|\]|\}|\>/) {
		if (@stack) {
			$el = pop @stack;
		} else {
			say "Fail";
			exit;
		}
		if ($el ne get_pair($_)) {
			say "Fail";
			exit;
		}
	}
}

if (@stack) {
	say "Fail";
} else {
	say "Success";
}
