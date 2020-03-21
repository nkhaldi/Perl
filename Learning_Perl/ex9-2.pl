#!/usr/bin/env perl

# Напишите программу, которая создает измененную копию
# текстового файла. В копии каждое вхождение строки Fred
# (с любым регистром символов) должно заменяться строкой Larry.
# Имя входного файла должно задаваться в командной строке
# (не запрашивайте его у пользователя!), а имя выходного файла
# образуется из того же имени и расширения .out.

use 5.018;
use warnings;

my $in = $ARGV[0];
die "Usage: $0 filename" unless defined $in;
my $out = $in;
$out =~ s/(\.\w+)?$/.out/;

die "Can't open '$in': $!" unless (open IN, "<$in");
die "Can't write '$out': $!" unless (open OUT, ">$out");

while (<IN>) {
	s/Fred/Larry/gi;
	print OUT $_;
}
