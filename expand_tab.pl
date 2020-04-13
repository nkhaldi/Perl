#!/usr/bin/env perl

# Скрипт для замены табуляции на пробелы

use 5.018;
use warnings;

$^I = ".bak";
while (<>) {
    s/\t/    /g;
    print;
}
