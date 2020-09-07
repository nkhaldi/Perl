#!/usr/bin/env perl

package JSONParser;

use 5.018;
use warnings;
no warnings 'experimental';
no warnings 'uninitialized';

use DDP;
use Encode;
use JSON::XS;

use base qw( Exporter );
our @EXPORT_OK = qw( parse_json );
our @EXPORT = qw( parse_json );

# Подбор парного элемента для " [ {
sub get_pair
{
    my ($str, $token) = @_;
    my $pair;

    $str =~ m/\Q$token\E/g;
    my $first = pos($str);

    given ($token) {
        when ('"') {
            $str =~ m/\G.*?(?<!\\)"/gc;
            return ($first, pos ($str));
        } when ('{') {
            $pair = '}';
        } when ('[') {
            $pair = ']';
        } default {
            last;
        }
    }

    my $count = 1;
    while ((pos ($str) < length ($str)) && ($count > 0) )
    {
        if ($str =~ /\G.*?([\Q$token|$pair\E])/sgc) {
            if ($1 eq $token) {
                $count++;
            } elsif ($1 eq $pair) {
                $count--;
            }
        } else {
            last;
        }
    }

    my $last = pos ($str);
    return ($first, $last);
}

# Unicode
sub parse_unicode
{
    my $str = shift;
    my %map = (
        'n' => "\n",
        't' => "\t",
    );

    $str = decode('utf8', $str);
    $str =~ s{\G(?:(?:\\(["\\/]))|(?:\\u(....))|(?:\\([tn]))|(.*?)(?=\\))}{ $1 ? $1 : $2 ? pack 'U*', hex($2) : $3 ? $map{$3} : $4 }ge;

    return $str;
}

# Парсинг строки
sub parse_string
{
    my $str = shift;

    my ($first, $last) = get_pair ($str, '"');        # Ищем пару для "
    my $res = substr $str, $first, ($last - $first - 1);    # Строка без "
    pos ($res) = 0;

    while (pos ($res) < length ($res))
    {
        if ($res =~ /\G([a-zA-Z0-9!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?\ ]+)/gc) {
            next;
        } elsif ($res =~ m!\G\\((?:[nt"\\/]|u[0-9a-fA-F]{4}))!gc) {
            next;
        } elsif ($res =~ m!\G\P{M}+!gc) {
            next;
        } else {
            return 0;
        }
    }

    return $res;
}

# Парсинг числа
sub parse_number
{
    my $str = shift;

    if ($str =~ m!(-?(?:0|[1-9][0-9]*)(?:\.\d+)?(?:[eE][+\-]*\d+)?)!) {
        $str = $1;
        return $str;
    } else {
        return 0;
    }
}

# Парсинг массива
sub parse_array
{
    my ($str) = @_;            # Массив, записанный в виде строки

    my ($first, $last) = get_pair ($str, '[');        # Ищем пару для [
    $str = substr $str, $first, ($last - $first - 1);    # Избавляемся от [ ]

    my $value;
    my @res = ();
    pos ($str) = 0;

    if ($str =~ m/^\s*$/) {        # Пустое значение
        return \@res;
    }

    OBJECT:

    $value = parse_value ($str);
    if (ref $value eq 'HASH') {                # Если ссылка на хэш.
        pos ($str) = (get_pair ($str, '{'))[1];        # то ищем }
    } elsif (ref $value eq 'ARRAY') {            # Если ссылка на массив,
        pos ($str) = (get_pair ($str, '['))[1];        # то ищем ]
    } else {
        if ($str =~ m/\G\s*"/) {                # Если строка,
            pos ($str) = (get_pair ($str, '"'))[1];        # то ищем "
            $value = parse_unicode ($value);        # и парсим управляющие символы            
        } else {
            $str =~ m/\G\s*/gc;
            pos ($str) += length ($value);
        }
    }

    push @res, $value;
    if ($str =~ m/\G\s*,/gc) {
        $str = substr $str, pos ($str);
        pos ($str) = 0;
        goto OBJECT;
    }

    if ($str =~ m/\G\s*$/g) {
        return \@res;
    } else { 
        die "JSON is not valid";
    }
}

# Парсинг объекта
sub parse_object
{
    my $str = shift;

    my ($first, $last) = get_pair ($str, '{');            # Ищем пару для {
    $str = substr $str, $first, ($last - $first - 1);        # Избавляемся от { }

    my $key;
    my $value;

    my %res;
    pos ($str) = 0;

    if ($str =~ m/^\s*$/) {        # Пустой объект
        return \%res;
    }

    NEXT:

    $key = parse_string ($str) or die "JSON is not valid";    # Считываем ключ
    $key = parse_unicode ($key);
    pos($str) = (get_pair ($str, '"'))[1];

    $str =~ m/\G\s*:/gc or die "JSON is not valid";        # Считываем значение
    $str = substr $str, pos ($str);
    pos ($str) = 0;
    $value = parse_value ($str);

    if (ref $value eq 'HASH') {                # Если ссылка на хэш,
        pos($str) = (get_pair($str, '{'))[1];        # ищем }
    } elsif (ref $value eq 'ARRAY') {            # Если ссылка на массив,
        pos ($str) = (get_pair($str, '['))[1];        # ищем ]
    } else {
        if ($str =~ m/\G\s*"/) {
            pos ($str) = (get_pair($str, '"'))[1];
            $value = parse_unicode ($value);
        } else {
            $str =~ m/\G\s*/gc;
            pos ($str) += length ($value);
        }
    }

    $res{$key} = $value;

    # Следующая пара
    if ($str =~ m/\G\s*,/gc) {
        $str = substr $str, pos ($str);
        pos ($str) = 0;
        goto NEXT;
    }

    return \%res if ($str =~ m/\G\s*$/gc) or die "JSON is not valid";
}

# Парсинг значения
sub parse_value
{
    my $source = shift;
    my $res;
    
    $source =~ m/^\s*([\{\[\"\d+\-])/;        # Матчим и захватываем следующий элемент
    given ($1) {
        when ('"') {                # Если " -> строка
            $res = parse_string($source);
        } when (m/\d|-/) {            # Если цифра или - -> число
            $res = parse_number($source);
        } when ('[') {                # Если [ - массив
            $res = parse_array($source);
        } when ('{') {                # Если { - объект
            $res = parse_object($source);
        } default {
            die "JSON is not valid!";
        }
    }

    return $res;
}

# Парсинг JSON
sub parse_json
{
    my $source = shift;

    if ($source !~ /^\s*[{\[].*[}\]]\s*$/s) {    # Если первый элемент не [ и не {
        die "JSON is not valid!";        # то JSON не валидный
    }

    # Образец
    # $res = JSON::XS->new->utf8->decode($source);

    my $res = parse_value($source);
    return $res;
}

1;
