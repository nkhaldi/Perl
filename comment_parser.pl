#!/usr/bin/env perl

use 5.018;
use warnings;
no warnings 'experimental';

$^I = ".copy";

my $path = "";
if (@ARGV) {
	for (@ARGV) {
		$path .= "$_ ";
	}
} else {
	$path = ".";
}

system("find $path -type f -name '*.c' > files");
system("find $path -type f -name '*.h' >> files");

my @files;
my $fd = open(FILES, '<', "files") or die "Can't open file";
while (<FILES>) {
	s/\n$//g;
	push(@files, $_);
}
close($fd);
system("rm files");

die "No such files" unless @files;
@ARGV = @files;

while (<>) {
	s/\s*\/\/.*//g;
	print;
}

for (@files) {
	system ("rm $_.copy");
}
say "***PARSED***";
