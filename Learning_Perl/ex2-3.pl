#!/usr/bin/env perl

# Измените программу из предыдущего упражнения так, чтобы
# при вводе отрицательного числа выдавался нуль
# (вместо отрицательной длины окружности)

use 5.018;
use warnings;

print "Enter radius: ";
chomp (my $rad = <>);

my $len = 0;
my $pi = 3.141592654;

if ($rad > 0) {
    $len = 2 * $pi * $rad;
}
say $len;
