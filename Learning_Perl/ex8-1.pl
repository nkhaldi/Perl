#!/usr/bin/env perl

# Создайте в тестовой программе шаблон для строки match.
# Запустите программу для входной строки beforematchafter.
# Выводятся ли в результатах все три части строки в правильном порядке?

use 5.018;
use warnings;

while (<>) {
	chomp;
	if (/match/) {
		say "$`<$&>$'";
	}
}
