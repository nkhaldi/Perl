#!/usr/bin/env perl

use 5.016;

@ARGV = ();
$^I = ".copy";

system('find . -type f -name "*.c" > files');
system('find . -type f -name "*.h" >> files');

my $fd = open(FILES, '<', "files") or die "Can't open file";
while (<FILES>) {
	s/\n$//g;
	push(@ARGV, $_);
}

close($fd);
system("rm files");
die "No such files" unless @ARGV;

while (<>) {
	s/\s*\/\/.*//g;
	print;
}

say "***PARSED***";
