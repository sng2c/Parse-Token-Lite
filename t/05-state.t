use strict;
use warnings;
use lib qw(./lib ../lib);
use Test::More tests => 22;                      # last test to print
use Data::Printer;

BEGIN{
	use_ok("Parse::Token::Simple");
}


my $text = q{<% $a=1 %> $b = 1};

my %rules = (
    MAIN=>[
	    {state_actions=>['+PLACEHOLDER'], re=>qr{<%}},
	    {name=>'NL', re=>qw{[\n]}},
	    {name=>'REST', re=>qw{.*}},
    ],
    PLACEHOLDER=>[
	    {name=>'VAR',re=>qr{\$\w+\s*=\s*}, state_actions=>['+VAR']},
	    {name=>'WS', re=>qr{\s+}},
	    {re=>qr{\%>}, state_actions=>['-PLACEHOLDER']},
    ],
    VAR=>[
	    {name=>'VAL',re=>qr{\w+}, state_actions=>['-VAR'] },
    ],
);

my $lexer = Parse::Token::Simple->new(rulemap=>\%rules);
$lexer->from($text);

my @token;

@token = $lexer->nextToken;
is( $token[0]->rule->name, undef);
is( $token[0]->data, '<%');
is( $token[0]->rule->state_actions->[0], '+PLACEHOLDER');

is( $lexer->state, 'PLACEHOLDER', 'Check State');

@token = $lexer->nextToken;
is( $token[0]->rule->name, 'WS');
is( $token[0]->data, ' ');

@token = $lexer->nextToken;
is( $token[0]->rule->name, 'VAR');
is( $token[0]->data, '$a=');
is( $token[0]->rule->state_actions->[0], '+VAR');

is( $lexer->state, 'VAR', 'Check State');

@token = $lexer->nextToken;
is( $token[0]->rule->name, 'VAL');
is( $token[0]->data, '1');
is( $token[0]->rule->state_actions->[0], '-VAR');

@token = $lexer->nextToken;
is( $token[0]->rule->name, 'WS');
is( $token[0]->data, ' ');

@token = $lexer->nextToken;
is( $token[0]->rule->name, undef);
is( $token[0]->data, '%>');
is( $token[0]->rule->state_actions->[0], '-PLACEHOLDER');

is( $lexer->state, 'MAIN', 'state check');

@token = $lexer->nextToken;
is( $token[0]->rule->name, 'REST');
is( $token[0]->data, ' $b = 1');

done_testing;
