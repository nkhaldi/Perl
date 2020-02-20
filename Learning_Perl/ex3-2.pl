#!/usr/bin/env perl

# Напишите программу, которая читает список чисел (в разных
# строках) до конца входных данных, а затем выводит для каждого
# числа соответствующее имя из приведенного ниже списка:
# fred betty barney dino wilma pebbles bammbamm

use 5.024;

my @names = qw/fred betty barney dino wilma pebbles bammbamm/;
chomp(my @numbers = <>);
for (@numbers) {
	say $names[$_ - 1];
}
