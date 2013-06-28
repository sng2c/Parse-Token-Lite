use strict;
use warnings;
use lib qw(./lib);
use Test::More  tests => 11;                      # last test to print
use Data::Printer;

BEGIN{
	use_ok("Parse::Token::Simple");
}


my $rulemap = {
    MAIN=>[
    {name=>'WORLD', re=>qr/world/},
	{name=>'CHR', re=>qr/./},
    ]
};

my $lexer = Parse::Token::Simple->new(rulemap=>$rulemap);
eval{ 
	$lexer->from("hello world");
};

fail('Check Implemented') if $@;

my @r;

@r = $lexer->nextToken;
is ($r[0]->name, 'CHR');
is ($r[1], 'h');

@r = $lexer->nextToken;
is ($r[1], 'e');

@r = $lexer->nextToken;
is ($r[1], 'l');

@r = $lexer->nextToken;
is ($r[1], 'l');

@r = $lexer->nextToken;
is ($r[1], 'o');

@r = $lexer->nextToken;
is ($r[1], ' ');

@r = $lexer->nextToken;
is ($r[0]->name, 'WORLD');
is ($r[1], 'world');

is $lexer->eof,1,'check EOF';

done_testing;
