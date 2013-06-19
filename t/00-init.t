use strict;
use warnings;

use Test::More tests => 1;                      # last test to print


BEGIN{
	use_ok("Parse::Token::Simple");
}


my @rules = (
	'CHR'=>[qr/./],
);

my $lexer = Parse::Token::Simple->new(rules=>\@rules);
eval{ 
	$lexer->from("hello world");
};

fail('Check Implemented') if $@;

is $lexer->nextToken,'h','Check token';
is $lexer->eof, 0, 'Check eof = 0';
is $lexer->nextToken,'e','Check token';
is $lexer->nextToken,'l','Check token';
is $lexer->nextToken,'l','Check token';
is $lexer->nextToken,'o','Check token';
is $lexer->nextToken,' ','Check token';
is $lexer->eof, 0, 'Check eof = 0';
is $lexer->nextToken,'w','Check token';
is $lexer->nextToken,'o','Check token';
is $lexer->nextToken,'r','Check token';
is $lexer->nextToken,'l','Check token';
is $lexer->nextToken,'d','Check token';
is $lexer->eof, 1, 'Check eof = 1';


