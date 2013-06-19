use strict;
use warnings;
use lib qw(./lib);
use Test::More; # tests => 1;                      # last test to print
use Data::Printer;

BEGIN{
	use_ok("Parse::Token::Simple");
}


my @rules = (
	['URL'=>qr@http://[a-zA-Z-_\%0-9/#=&\?\.]+@],
    ['WS'=>qr/\s+/],
    ['DELI'=>qr@["'<>/=]+@],
    ['WORD'=>qr@[^"'<>/=\s]+@],
);

my $html = <<END;
<html>
<body>
<a href='http://mabook.com'>mabook</a>
</body>
</html>
END

my $lexer = Parse::Token::Simple->new(rules=>\@rules);
$lexer->from($html);
my @token;

my $url;
while(!$lexer->eof){
    @token = $lexer->nextToken;
    if( $token[0] eq 'URL'){
        $url = $token[1];
    }
    print "$token[0]\t: '$token[1]'\n";
}
is( $url, 'http://mabook.com', 'detect URL');
done_testing;
