use strict;
use warnings;
use lib qw(./lib);
use Test::More; # tests => 1;                      # last test to print
use Data::Printer;

BEGIN{
	use_ok("Parse::Token::Simple");
}


my @rules = (
	['CHR'=>qr/./],
);

eval{
my $lexer_bad = Parse::Token::Simple->new();
};
ok( $@ =~/Missing required arguments: rules/ , 'Required ARG' );


my $lexer = Parse::Token::Simple->new(rules=>\@rules);
eval{ 
	$lexer->from("hello world");
};

fail('Check Implemented') if $@;

my @r;

@r = $lexer->nextToken;
is ($r[0], 'CHR');
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
is ($r[1], 'w');

@r = $lexer->nextToken;
is ($r[1], 'o');

@r = $lexer->nextToken;
is ($r[1], 'r');

@r = $lexer->nextToken;
is ($r[1], 'l');

is $lexer->eof,0,'check EOF';

@r = $lexer->nextToken;
is ($r[1], 'd');

is $lexer->eof,1,'check EOF';

done_testing;
