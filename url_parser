#!/usr/bin/env perl

use 5.016;
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
