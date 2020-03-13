#!/usr/bin/env perl

use 5.024;

$SIG{INT} = sub {
	say "\n\033[31mIMMORTALITY!\033[0m";
};

my $gen = 0;
while(1)
{
	$gen++;
	my $pid = fork();
	die "fork: $!" unless defined $pid;

	if ($pid) {
		$0 = "Immortal:master:$gen";
		say "[$$] Master: have child $pid";
		waitpid($pid,0);
		say "[$$] Child gone";

	} else {
		my $master = getppid();
		$0 = "Immortal:child:$gen";
		say "[$$] Child: my master: $master";
		while (1) {
			if (kill 0 => $master) {
				say "Process $master is alive";
			} else {
				say "\n\033[36mREGENERATION!\033[39m";
				last;
			}
			sleep 1;
		}
	}
}
