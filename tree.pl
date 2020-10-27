#!/usr/bin/env perl

use 5.018;
use warnings;
no warnings 'experimental';

use DDP;
use Getopt::Long;


$|++;

my $pid = $$;
my $help = 0;
my $message = "
 --help     - Add this option to get help
 --all      - Add this option to print tree of all processes executed on OS
 --pid=n    - Add this option to print tree starting from transmitted process Id
 --features=...    - Add this option to print tree with specified parameters:
          pid - process identifier,
          uid - user identifier,
          gid - group identifier\n";

my @features = ();
GetOptions (
    'all!' => \$pid,
    'help!' => \$help,
    'pid=i' => \$pid,
    'features=s{1,3}' => \@features,
) or die "Usage arguments\n$message";

die $message if $help;

$_ =~ s/[^\w+]//g for @features;
my %params = map { $_ => 1 } @features;

# Список процессов
my @list;
opendir(my $dh, '/proc') or die $!;
while (readdir $dh) {
        push @list, $_ if /^\d+$/
}
closedir $dh;

# Хэш ppid => [pids]
my %hash;
for (@list) {
    my %stat = parse_status($_);
    my $ppid = $stat{ppid};
    if (exists $hash{$ppid}) {
        push @{ $hash{$ppid} }, $_;
    } else {
        $hash{$ppid} = [$_];
    }
}

print_tree(\%hash, $pid, '');

# Вывод дерева
sub print_tree {
    my $href = shift;
    my $pid = shift;
    my $el = shift;

    my %hash = %$href;

    my $name;
    my $uid;
    my $gid;

    my %stat = parse_status($pid);

    $uid = $stat{uid} if $pid;
    $gid = $stat{gid} if $pid;

    $name = $stat{name} if $pid;
    $name = "zero" unless $pid;

    state $gen = -1;
    $gen++;

    print "\t" x $gen;
    print $el if $gen;

    print $name;

    print '─' x (18 - length $name) if exists $params{pid};
    print $pid if exists $params{pid};

    say "" if exists $params{uid};
    print "\t" x $gen;
    print "│ uid: $uid" if exists $params{uid};

    say "" if exists $params{gid};
    print "\t" x $gen;
    print "│ gid: $gid" if exists $params{gid};
    say "";

    for my $i (0..$#{ $hash{$pid} }) {
        if ($i == $#{ $hash{$pid} }) {
            $el = '└─';
        } else {
            $el = '├─';
        }
        $el = '┬─' unless $i;

        print_tree($href, ${ $hash{$pid} }[$i], $el);
        $gen--;
    }
}

# Статус процесса
sub get_status {
    my $pid = shift;

    open (my $f, '<', "/proc/$pid/status") or die "No such process: $pid\n";
    my $read = sysread ($f, my $buff, 4096);

    die "Error while reading" unless defined $read;
    warn "Nothing has been read" unless $read;

    my @status = split m{\n}, $buff;
    close ($f) or warn $!;

    return @status;
}


# Функция вовращает оспеределённый параметр процесса
sub parse_status {
    my $pid = shift;
    my @status = get_status($pid) if $pid;

    my %stat_hash = (
        name => undef,
        ppid => undef,
        uid => undef,
        gid => undef,
    );

    for my $key (keys %stat_hash) {
        for my $stat (@status) {
            if ($stat =~ /^$key/i) {
                $stat =~ s/^\w+\:\s+//;
                $stat_hash{$key} = $stat;
                last;
            }
        }
    }

    $stat_hash{uid} =~ s/^(\d+)(.)*/$1/;
    $stat_hash{gid} =~ s/^(\d+)(.)*/$1/;

    return %stat_hash;
}

# Хэш процессов ppid => [pids]
sub hash_ppid_pids {
    my @list = @_;
    my %hash;

    for (@list) {
        my %stat = parse_status($_);
        my $ppid = $stat{ppid};
        if (exists $hash{$ppid}) {
            push @{ $hash{$ppid} }, $_;
        } else {
            $hash{$ppid} = [$_];
        }
    }
    return \%hash;
}
