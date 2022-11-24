#!/usr/bin/env perl

use 5.018;

use JSON;
use Data::Dumper;
use WWW::Curl::Easy;

use constant {
    URL => "https://www.cbr-xml-daily.ru/daily_json.js"
};


my $curl = WWW::Curl::Easy->new();
