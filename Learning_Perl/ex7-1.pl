#!/usr/bin/env perl

# Напишите программу, выводящую каждую строку входных данных,
# в которой присутствует слово fred.
# Создайте небольшой текстовый файл, в котором упоминаются
# fred flintstone и его друзья. Используйте его для
# передачи входных данных этой и другим программам этого раздела.

use 5.018;
use warnings;

while (<>) {
	print if (/fred/);
}
