#!/usr/bin/env perl

# Упражнение на «совсем повышенную оценку»: измените
# предыдущую программу так, чтобы она не изменяла файлы,
# уже содержащие строку с информацией об авторских правах.
# (Подсказка: имя файла, из которого оператор <> читает данные, хранится
# в $ARGV.)

use 5.018;
use warnings;

my %files;
for (@ARGV) {
    $files{$_} = 1;
}

while (<>) {
    if (/^## Copyright/) {
        delete $files{$ARGV};
    }
}

@ARGV = sort keys %files;
$^I = ".bak";
while (<>) {
    if (/^#!/) {
        $_ .= "## Copyright (c) 20XX by Yours Truly\n";
    }
    print;
}
