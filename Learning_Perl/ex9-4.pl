#!/usr/bin/env perl

# Упражнение «на повышенную оценку»: напишите программу,
# которая включает в любую программу из упражнений строку
# с информацией об авторских правах следующего вида:
# ## Copyright (C) 20XX by Yours Truly
# Строка должна размещаться сразу же за строкой с «решеткой».
# Файл следует изменять «на месте» с сохранением резервной копии.
# Считайте, что при запуске программы имена изменяемых файлов
# передаются в командной строке.

use 5.018;
use warnings;

$^I = ".bak";
while (<>) {
    if (/^#!/) {
        $_ .= "## Copyright (C) 20XX by Yours Truly\n";
    }
    print;
}
