#!/usr/bin/env perl

# Напишите пользовательскую функцию с именем greet.
# Функция приветствует человека по имени и сообщает ему имя,
# использованное при предыдущем приветствии.

use 5.024;

sub greet {
	state $prev = 0;
	my $name = shift;

	print "Hello, $name! ";
	if ($prev) {
		say "$prev is also here!";
	} else {
		say "You're the first one here!";
	}
	$prev = $name;
}
