use 5.024; # strict enabled by default
use warnings;

use DDP;

chomp (my $input = <>);
my @brackets = split //, $input;

for (@brackets) {
	say;
}
