#!/usr/bin/env perl

# Напишите программу для вывода входных строк,
# в которых присутствуют оба слова wilma и fred.

use 5.018;
use warnings;

while (<>) { 
    print if (/(wilma.*fred)|(fred.*wilma)/);
}
