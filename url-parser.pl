#!/usr/bin/env perl

use 5.018;
use warnings;
no warnings 'experimental';

use DDP;

while (<>) {
	chomp;
	my %hash;
	%hash = parse_url($_);
	say;
	p %hash;
}

sub parse_url {
	my $url = shift;
    
	$url =~	/^((?<schema>[^(:)]*):)?
		\/\/(?<domain>[\w\.-]*)
		(:(?<port>\d+))?
		(?<path>[^?#]*)?
		(\?(?<query_string>[^#]+))?
		(\#(?<anchor>.*))?
		/x;

	return %+;
}
