package Local::Calc;

use 5.018;
use warnings;

use Scalar::Util qw(looks_like_number);
use DDP;

BEGIN {
	if ($] < 5.018) {
		package experemental;
		use warnings::register;
	}
}
no warnings 'experemental';
no warnings 'uninitialized';

use Exporter 'import';
our @EXPORT_OK = qw(tokenize rpn evaluate);

# Токенизация
sub tokenize
{
	chomp(my $expr = shift);	# "10 + 20 - 30"
	$expr =~ s/\s//g;			# "10+20-30"
	$expr =~ s/E/e/g;			# '10E2' -> '10e2'

	# Если операнд не число	
	my @expr_check = split m{[-+*/^)(]}, $expr;	# '10' '20' '30'
	@expr_check = grep {length $_ } @expr_check;
	for my $val (@expr_check)
	{
		die "NaN" if (!($val =~ /\d/));
	}

	my @res = split m{([-+*/^)(])}, $expr;		# '10', '+', '20', '-', '30'
	@res = grep {length $_ } @res;				# '10', '+', '', '-', '20' -> '10', '+', '-', '20'

	my @chars;
	for my $i (1..($#res-1))
	{					# '10e', '+', '2' -> '10e+2'
		@chars = split //, $res[$i-1];
		if ((($res[$i] eq '+') || ($res[$i] eq '-')) && ($chars[-1] eq 'e') && ($res[$i+1] =~ /\d/)) {
			$res[$i] = $res[$i-1].$res[$i].$res[$i+1];
			$res[$i-1] = '';
			$res[$i+1] = '';
		}
		@res = grep {length $_ } @res;
	}

	for my $val (@res)
	{
		if ($val =~ /\d/) {
			if (looks_like_number($val)) {
				$val = $val + 0;	# "10e2, 10e+2, .5, " -> "1000, 1000, 0.5"
			} else {
				die "NaN";
			}
		}
	}
	
	my $first_sign = shift @res;
	if ($first_sign eq '-') {		# "- 10 + 20" -> "U- 10 + 20"
		unshift @res, 'U-';
	} elsif ($first_sign eq '+') {		# "+ 10 + 20" -> "U+ 10 + 20"
		unshift @res, 'U+';
	} elsif (($first_sign =~ /\d/) || ($first_sign eq '(')) {
		unshift @res, $first_sign;	# "(10 + 20) * 30
	} else {
		die "Error: first sign";
	}
	
	# Если последний элемент не число и не ')'
	die "NaN" if (($res[-1] ne ')') && !($res[-1] =~ /\d/));

	# Унарные + и -
	for my $i (1..$#res)
	{
		if (!($res[$i-1] =~ /\d/) && ($res[$i-1] ne ')')) {
			if ($res[$i] eq '-') {
				$res[$i] = 'U-';	# "10 + - 20" -> "10 + U- 20"
			} elsif ($res[$i] eq '+') {
				$res[$i] = 'U+';	# "10 + + 20" -> "10 + U+ 20"
			}
		}
	}

        for my $i (1..$#res)
	{
		if (($res[$i] eq '(') && (($res[$i-1] =~ /\d/) || ($res[$i-1] eq ')'))) {
			@res = (@res[0..$i-1], '*', @res[$i..$#res]);           # "10 (20)" -> "10 * (20)"
		}
	}
	for my $i (1..$#res)
	{
		if (($res[$i-1] eq ')') && ($res[$i] =~ /\d/)) {
			@res = (@res[0..$i-1], '*', @res[$i..$#res]);           # "(10) 20" -> "(10) * 20"
		}
	}

	for my $i (1..$#res) {
		# Отдельно учитываем ошибки ввода для скобок
		if (($res[$i-1] eq '(') || ($res[$i-1] eq ')') || ($res[$i] eq '(') || ($res[$i] eq ')')) { 
			if (($res[$i-1] eq '(') && ($res[$i] ne '(') && !($res[$i] =~ /\d/) && ($res[$i] ne 'U-') && ($res[$i] ne 'U+')) {
				die "Error: brackets 1";
			} elsif (($res[$i] eq ')') && (!($res[$i-1] =~ /\d/) && ($res[$i-1] ne ')'))) {
                                die "Error: brackets 2";
			}
		# И отдельно для остальных операторов
		} else {
			if (($res[$i-1] eq 'U-') || ($res[$i-1] eq 'U+')) {
				die "Error: not brackets 1" if (!($res[$i] =~ /\d/) && ($res[$i] ne 'U+') && ($res[$i] ne 'U-'));
			} elsif (!($res[$i-1] =~ /\d/) && !($res[$i] =~ /\d/) && ($res[$i] ne 'U-') && ($res[$i] ne 'U+')) {
				die "Error: not brackets 2";
			}
		}
	}
	
	return \@res;
}

# Обратная Польская Нотация
sub rpn
{
	my $expr = shift;
	my $source = tokenize($expr);	# Входной массив
	my @rpn;			# Выходной массив
	my @stack;			# Стек
	my $el;				# Токен
	my $temp;			# Временная переменная

	while (@$source)
	{
		$el = shift @$source;
		
		# Число 
		if ($el =~ /\d/) {
			push @rpn, $el;
			next;
		}

		# '('
		if ($el eq '(') {
			push @stack, $el;
			next;
		}
		
		# ')'
		if ($el eq ')') {
			while (1)
			{
				if (@stack) {
					$el = pop @stack;
					if ($el ne '(') { push @rpn, $el;}
					else { last; }
				} else { die "Error: brackets" }
			}
			next;
		}

		# '+' или '-'
		if (($el eq '+') || ($el eq '-')) {
			while (1)
			{
				if (@stack) {
					$temp = pop @stack;
					if (($temp ne '(') && ($temp ne ')')) {
						push @rpn, $temp;
						next;
					} else {
						push @stack, $temp;
						push @stack, $el;
						last;
					}
				} else {
					push @stack, $el;
					last;
				}
			next;
			}
		}

		# '*' или '/'
		if (($el eq '*') || ($el eq '/')) {
			while (1)
			{       
				if (@stack) {
					$temp = pop @stack;
					if (($temp ne '(') && ($temp ne ')') && ($temp ne '+') && ($temp ne '-')) {
						push @rpn, $temp;
						next;
					} else {
						push @stack, $temp;
						push @stack, $el;
						last;
					}
				} else {
					push @stack, $el;
					last;
				}
			next;
			}
		}
			
		# 'U-' или 'U+'
		if (($el eq 'U-') || ($el eq 'U+')) {
			push @stack, $el;
		}

		# '^'
		if ($el eq '^') {
			push @stack, $el;
			next;
		}
	}

	while (@stack)
	{
		$el = pop @stack;
		push @rpn, $el;
	}

	return \@rpn;
}

# Вычисление
sub evaluate {
	my $rpn0 = shift;	# Очередь в форме ОПН	
	my @rpn = @$rpn0;

	my @stack;		# Стек вычислений
	my $token;		# Токен

	my $val1, my $val2;	# Операнды
	my $res;		# Результат

	while (@rpn)
	{
		$token = shift @rpn;

		# Число
		if ($token =~ /\d/) {
			push @stack, $token;
			next;
		} 

		# Унарные операции
		if (($token eq 'U-') || ($token eq 'U+')) {
			$val1 = pop @stack;

			# 'U-'
			if ($token eq 'U-') {
				$res = 0 - $val1;
				push @stack, $res;
				next;

			}

			# 'U+'
			if ($token eq 'U+') {
				$res = $val1;
				push @stack, $res;
				next;
			}

		# Бинарные операции
		} else { 
			$val1 = pop @stack;
			$val2 = pop @stack;
		}

		# '+'
		if ($token eq '+') {
			$res = $val2 + $val1;
			push @stack, $res;
			next;
		}

		# '-'
		if ($token eq '-') {
			$res = $val2 - $val1;
			push @stack, $res;
			next;
		}

		# '*'
		if ($token eq '*') {
			$res = $val2 * $val1;
			push @stack, $res;
			next;
		}

		# '/'
		if ($token eq '/') {
			die "\nError: division by 0\n\n" if ($val1 == 0);

			$res = $val2 / $val1;
			push @stack, $res;
			next;
		}

		# '^'
		if ($token eq '^') {
			$res = $val2 ** $val1;
			push @stack, $res;
			next;
		}
	}

	$res = pop @stack;
	return $res;
}

1;
