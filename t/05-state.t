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
	['REP+'         =>qr{<%}],
	['REP:VAR+'     =>qr{\$\w+\s*=\s*}],
	['REP:VAR- VAL' =>qr{\w+} ],
	['REP WS'       =>qr{\s+}],
	['REP-'         =>qr{\%>}],
	[NL=>qw{[\n]}],
	[ERR=>qw{.*}],
);

my $lexer = Parse::Token::Simple->new(rules=>\@rules);
$lexer->from($text);

while(!$lexer->eof){
	my @token = $lexer->nextToken;
	p @token;
}
done_testing;
