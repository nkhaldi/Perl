#!/usr/bin/env perl

# Напишите программу для вывода всех ключей и значений в %ENV.
# Выведите результаты в два столбца в ASCIIQалфавитном порядке.
# Отформатируйте результат так, чтобы данные в обоих столбцах
# выравнивались по вертикали. Функция length поможет вычислить
# ширину первого столбца. Когда программа заработает,
# попробуйте задать новые переменные среды и убедитесь в том,
# что они присутствуют в выходных данных.

use 5.018;
use warnings;

my $maxl = 0;

for my $key (keys %ENV) {
    $maxl = length($key) if length($key) > $maxl;
}

for my $key (sort keys %ENV) {
    printf "%${maxl}s %s\n", $key, $ENV{$key};
}
