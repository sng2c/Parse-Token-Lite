use strict;
use warnings;
use lib qw(./lib ../lib);
use Test::More; # tests => 1;                      # last test to print
use Data::Printer;

BEGIN{
	use_ok("Parse::Token::Simple");
}


my $text = q{<% $a = 1 %> $b = 1};

my @rules = (
	['PLACEHOLDER+:'         =>qr{<%}],
	['VAR+:VAR'             =>qr{\$\w+\s*=\s*}],
	['VAR-:VAL'             =>qr{\w+} ],
	['PLACEHOLDER:WS'       =>qr{\s+}],
	['PLACEHOLDER-:'         =>qr{\%>}],
	[NL=>qw{[\n]}],
	[REST=>qw{.*}],
);

my $lexer = Parse::Token::Simple->new(rules=>\@rules);
$lexer->from($text);

my @token;

@token = $lexer->nextToken;
is( $token[0], 'PLACEHOLDER:');
is( $token[1], '<%');
is( $token[2], '+');

is( $lexer->state, 'PLACEHOLDER', 'Check State');

@token = $lexer->nextToken;
is( $token[0], 'PLACEHOLDER:WS');
is( $token[1], ' ');
is( $token[2], '');

@token = $lexer->nextToken;
is( $token[0], 'VAR:VAR');
is( $token[1], '$a = ');
is( $token[2], '+');

is( $lexer->state, 'VAR', 'Check State');

@token = $lexer->nextToken;
is( $token[0], 'VAR:VAL');
is( $token[1], '1');
is( $token[2], '-');

@token = $lexer->nextToken;
is( $token[0], 'PLACEHOLDER:WS');
is( $token[1], ' ');
is( $token[2], '');

@token = $lexer->nextToken;
is( $token[0], 'PLACEHOLDER:');
is( $token[1], '%>');
is( $token[2], '-');

is( $lexer->state, '', 'state check');

@token = $lexer->nextToken;
is( $token[0], 'REST');
is( $token[1], ' $b = 1');
is( $token[2], '');

done_testing;
