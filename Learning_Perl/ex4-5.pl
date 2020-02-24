#!/usr/bin/env perl

# Измените предыдущую программу так, чтобы она сообщала
# имена всех людей, которых она приветствовала ранее.

use 5.024;

sub greet {
	state @prev;
	my $name = shift;

	print "Hello, $name! ";
	if (@prev) {
		say "I've seen @prev.";
	} else {
		say "You're the first one here!";
	}
	push @prev, $name;
}
