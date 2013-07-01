#!/usr/bin/env perl o
use lib './lib';
use Parse::Token::Simple;

my %rules = ( 
		MAIN=>[
				{ name=>'NUM', re=> qr/\d[\d,\.]*/ },
				{ name=>'STR', re=> qr/\w+/ },
				{ name=>'SPC', re=> qr/\s+/ },
				{ name=>'ERR', re=> qr/.*/ },
		],  
);  

my $parser = Parse::Token::Simple->new(rulemap=>\%rules);
$parser->from("This costs 1,000won.");
while( ! $parser->eof ){
		my ($token,@extra) = $parser->nextToken;
		print $token->rule->name."-->".$token->data."<--\n";
}   
