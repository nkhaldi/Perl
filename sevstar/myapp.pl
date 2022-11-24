#!/usr/bin/env perl

use Data::Dumper;
use Mojolicious::Lite -signatures;


get '/' => sub ($c) {
  $c->render(text => '<b>HELLO WORLD!</b>');
};


get '/dump' => sub ($c) {
    $c->render(text => "request: " . Dumper($c->req));
};


get '/agent' => sub ($c) {
  my $host = $c->req->url->to_abs->host;
  my $ua   = $c->req->headers->user_agent;
  $c->render(text => "Request by $ua reached $host.");
};


post '/echo' => sub ($c) {
  $c->res->headers->header('X-Bender' => 'Bite my shiny metal ass!');
  $c->render(data => $c->req->body);
};


app->start;
