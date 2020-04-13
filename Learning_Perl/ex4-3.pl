#!/usr/bin/env perl

# Напишите пользовательскую функцию above_average, 
# которая получает список чисел и возвращает те из них,
# которые превышают среднее арифметическое группы.
# Подсказка: напишите отдельную функцию для вычисления среднего
# арифметического делением суммы на количество элементов.

use 5.018;
use warnings;

sub total {
    my $sum = 0;
    for (@_) {
        $sum += $_;
    }
    return $sum;
}

sub average {
    return total(@_) / ($#_ + 1);
}

sub above_average {
    my $av = average(@_);
    my @res;

    for (@_) {
        if ($_ > $av) {
            push @res, $_;
        }
    }
    return @res;
}
