#!/usr/bin/env perl

# Напишите программу, которая запрашивает у пользователя
# имя и выводит соответствующую фамилию из хеша.

use 5.024;

my %names = qw/
	Narek Meliksetyan
	Polina Kaplenkova
	Kirill Ilichev
	Karen Melisketyan
	Vladimir Putin
/;

chomp (my $name = <>);
say "$names{$name}";
