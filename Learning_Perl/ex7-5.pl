#!/usr/bin/env perl

# Напишите программу, которая выводит каждую строку с двумя
# смежными одинаковыми символами, не являющимися символами пропусков.
# Программа должна находить совпадение в строках,
# содержащих слова вида Mississippi, BammBamm и llama.

use 5.018;
use warnings;

while (<>) {
	print if (/(\S)\1/);
}
