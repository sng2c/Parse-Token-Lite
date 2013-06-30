#!/usr/bin/env perl 
use lib './lib';
use Parse::Token::Simple;

my %rules = (
    MAIN=>[
    { name=>NUM, re => qr/\d[\d,\.]*/ },
    { name=>STR, re => qr/\w+/ },
    { name=>SPC, re => qr/\s+/ },
    { name=>ERR, re => qr/.*/ },
    ]
);

my $parser = Parse::Token::Simple->new(rulemap=>\%rules);
$parser->from("This costs 1,000won.");
while( ! $parser->eof ){
    my($token, @rest) = $parser->nextToken;
    my $state_tag = $token->rule->name;
    my $data = $token->data;
    print "$state_tag -->$data<--\n";
}
