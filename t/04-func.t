use strict;
use warnings;
use lib qw(./lib ../lib);
use Test::More; # tests => 1;                      # last test to print
use Data::Printer;

BEGIN{
	use_ok("Parse::Token::Simple");
}


my @rules = (
	['SET'=>qr/\$\w+\s*=\s*.+?;?/=>
		sub{
			my($lexer,$name,$matched) = @_;
			if( $matched =~ /(.+?)\s*=\s*(.+?);?/ ){
				return {var=>$1, val=>$2};
			}
		}
	],
	['DELIMETER'=>qr/\W/],
);

my $lexer = Parse::Token::Simple->new(rules=>\@rules);
eval{ 
	$lexer->from(q{$a=2;$b=3;});
};

fail('Check Implemented') if $@;

my @r;

@r = $lexer->nextToken;
is $r[3]->{var},'$a';
is $r[3]->{val},'2';

@r = $lexer->nextToken;
is $r[3]->{var},'$b';
is $r[3]->{val},'3';

is $lexer->eof,1,'check EOF';

done_testing;
