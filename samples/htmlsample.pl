#!/usr/bin/env perl 
use lib './lib';
use Parse::Token::Simple;

my @rules = (
	[ 'TAGIN>TAG'	=> qr/<\w+/ ],
	[ 'TAG:SPC' => qr/\s+/ ],
	[ 'TAG:NEW' => qr/\n+/ ],
	
	[ 'TAG:LEFT>RIGHT'=> qr/\w+\s*=/ ],
	
	[ 'RIGHT:>QQ' => qr/"/ ],
	[ 'QQ:VAL' => qr/[^"]+/ ],
	[ 'QQ:<QQ,<RIGHT' => qr/"/],

	[ 'RIGHT:>Q' => qr/'/ ],
	[ 'Q:VAL' => qr/[^']+/ ],
	[ 'Q:<Q,<RIGHT' => qr/'/],

	[ 'TAG:TAGOUT<TAG'	=> qr/>/ ],
	[ 'TAG:ERR' => qr/\w+/],
	
	[ SPC => qr/\s+/ ],
	[ NEW => qr/\n+/ ],
    [ ERR 		=> qr/.+/ ],
);

my $html = <<END;
<html>
	<body>
		<a href="http://www.daum.net">daum</a>
		<a href='http://www.daum.net'>daum</a>
		<a href='http://www.daum.net/"abc"'>daum</a>
	</body>
</html>
END

my $parser = Parse::Token::Simple->new(rules=>\@rules);
$parser->from($html);
while( ! $parser->eof ){
    my($state_tag, $token) = $parser->nextToken;
    print "$state_tag : $token \n" if $state_tag =~ /VAL/;
}
