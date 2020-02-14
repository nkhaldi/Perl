use 5.024; # strict enabled by default
use warnings;

use DDP;

chomp (my $input = <>);

my $el = 0;
my $err = -1;
my @stack = ();
my @brackets = split //, $input;

sub get_pair {
	$el = shift;

	if ($el eq '(') {
		return ')';
	} elsif ($el eq ')') {
		return '(';
	} elsif ($el eq '[') {
		return ']';
	} elsif ($el eq ']') {
		return '[';
	} elsif ($el eq '{') {
		return '}';
	} elsif ($el eq '}') {
		return '{';
	}
	return 0;
}

while (@brackets) {
	$_ = shift @brackets;
	if (/\[|\(|\{/) {
		push @stack, $_;
		next;
	} elsif (/\)|\]|\}/) {
		p @stack;
		$el = pop @stack;
		say "el = $el";
		if (!$el) {
			$err++;
			say $err;
			exit;
		} elsif ($el ne get_pair($_)) {
			say "\$_ = $_";
			say "pair = " . get_pair($_);
			$err++;
			say $err;
			exit;
		}
	}
}

if (@stack) {
	say $err;
} else {
	say "Success";
}
