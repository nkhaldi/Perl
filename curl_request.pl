#!/usr/bin/env perl

use 5.018;

use JSON;
use Data::Dumper;
use WWW::Curl::Easy;

use constant {
    VER => 0,
    URL => "https://www.cbr-xml-daily.ru/daily_json.js",
};


my $curl = WWW::Curl::Easy->new;
$curl->setopt(CURLOPT_URL, URL);
$curl->setopt(CURLOPT_VERBOSE, VERB);
$curl->setopt(CURLOPT_SSL_VERIFYHOST, 0);
$curl->setopt(CURLOPT_SSL_VERIFYPEER, 0);

my $response;
$curl->setopt(CURLOPT_WRITEDATA, \$response);
my $retcode = $curl->perform;
my $respcode = $curl->getinfo(CURLINFO_HTTP_CODE);

say "$retcode - $respcode";
say $response;
