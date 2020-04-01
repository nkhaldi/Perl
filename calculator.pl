#!/usr/bin/env perl

use 5.010;  # for say, given/when
use strict;
use warnings;

BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
no warnings 'experimental';

use Modules::Calc qw(rpn evaluate);

while (my $expression = <>) {
	say "RPN: " . rpn($expression);
	say "Eval: " . evaluate($expression);
}
