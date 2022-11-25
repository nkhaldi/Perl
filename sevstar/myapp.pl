#!/usr/bin/env perl

use JSON;
use Data::Dumper;

use Mojo::Pg;
use Mojolicious::Lite -signatures;


my $pg = Mojo::Pg->new('postgresql://postgres@/test');


get '/' => sub ($c) {
    $c->render(text => '<b>HELLO WORLD!</b>');
};


get '/dbversion' => sub ($c) {
    $c->render(text => $pg->db->query('SELECT VERSION() AS version')->hash->{version});
};


get '/dump' => sub ($c) {
    my $text = '';
    for my $key (keys %{$c->req}) {
        $text .= "$key<br>";
    }
    $c->render(text => $text);
};


get '/agent' => sub ($c) {
    my $host = $c->req->url->to_abs->host;
    my $ua = $c->req->headers->user_agent;
    $c->render(text => "Request by $ua reached $host.");
};


post '/echo' => sub ($c) {
    $c->res->headers->header('X-Bender' => 'Bite my shiny metal ass!');
    $c->render(data => $c->req->body);
};


app->start;
