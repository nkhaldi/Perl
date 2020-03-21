#!/usr/bin/env perl

# Напишите программу, которая запрашивает и получает два числа
# (в разных строках ввода), а затем выводит их произведение.

use 5.018;
use warnings;

say "Enter 2 numbers:";
chomp (my $a = <>);
chomp (my $b = <>);
my $c = $a * $b;
say "$a * $b = $c"
