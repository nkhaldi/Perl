#!/user/bin/env perl

use 5.010;
use DDP;

sub reduce(&@) {
	my ($f, @list) = @_;

	my $res = undef;
	for (@list) {
		$res = $f->($res, $_);
	}

	return $res;
}

# returns 10
my $s = reduce {
	my ($sum, $i) = @_;
	$sum + $i;
} 1, 2, 3, 4, 5;
say "sum:";
p $s;

# returns hash
my $h = reduce {
	my ($uniq, $c) = @_;
	$uniq->{$c}++,
	$uniq,
} 'b', 'b', 'a', 'c';
say "hash:";
p $h;
