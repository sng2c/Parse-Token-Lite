use strict;
use warnings;
use lib qw(./lib);
use Test::More; # tests => 1;                      # last test to print
use Data::Printer;

BEGIN{
	use_ok("Parse::Token::Simple");
}


my @rules = (
	['WORLD'=>qr/world/],
);

my $lexer = Parse::Token::Simple->new(rules=>\@rules);
eval{ 
	$lexer->from("hello world");
};

fail('Check Implemented') if $@;

my @r;

eval{
@r = $lexer->nextToken;
};
ok ($@);

done_testing;
