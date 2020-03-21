#!/usr/bin/env perl

# Напишите новую программу, которая выводит все входные строки,
# завершающиеся пропуском (кроме символов новой строки).
# Чтобы пропуск был виден при выводе, завершите выходную строку маркером.

use 5.018;
use warnings;

while (<>) {
	chomp;
	if (/\s+$/) {
		say "$_#";
	}
}
