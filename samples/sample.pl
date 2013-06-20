#!/usr/bin/env perl 
use lib './lib';
use Parse::Token::Simple;

my @rules = (
    [ NUM => qr/\d[\d,\.]*/ ],
    [ STR => qr/\w+/ ],
    [ SPC => qr/\s+/ ],
    [ ERR => qr/.*/ ],
);

my $parser = Parse::Token::Simple->new(rules=>\@rules);
$parser->from("This costs 1,000won.");
while( ! $parser->eof ){
    my($state_tag, $token) = $parser->nextToken;
    print "$state_tag -->$token<--\n";
}
