#!/usr/bin/env perl

# Создайте в тестовой программе шаблон, совпадающий с любым
# словом (в смысле \w), завершающимся буквой a.
# Опробуйте его на текстовом файле из упражнений
# предыдущей главы (и добавьте тестовые
# строки, если они не были добавлены ранее).

use 5.018;
use warnings;

while (<>) {
    chomp;
    if (/a\b/) {
        say;
    }
}
