#!/usr/bin/env perl 
use lib './lib','../lib';
use Parse::Token::Simple;

my @rules = (
	[ 'OPENTAG>TAG'	=> qr/<\w+/ ],
	[ 'CLOSETAG'	=> qr@</[^>]+?>@ ],

	[ 'TAG:SPC' => qr/\s+/ ],
	[ 'TAG:NEW' => qr/\n+/ ],
	
	[ 'TAG:LEFT>RIGHT'=> qr/\w+\s*=/ ],
	
	[ 'RIGHT:>Q2' => qr/"/ ],
	[ 'Q2:VAL' => qr/[^"]+/ => \&show ],
	[ 'Q2:<Q2,<RIGHT' => qr/"/],

	[ 'RIGHT:>Q1' => qr/'/ ],
	[ 'Q1:VAL' => qr/[^']+/ => \&show ],
	[ 'Q1:<Q1,<RIGHT' => qr/'/],

	[ 'TAG:TAGOUT<TAG'	=> qr/>/ ],
	
	[ SPC => qr/[\n\s]+/ ],
	[ STR => qr/\w+/ ],
	[ STR2 => qr/\W+/ ],
);

my $html = <<END;
<html>
	<body>
		<a href="http://www.daum.net">daum</a>
		<a href='http://www.daum.net'>daum</a>
		<a href='http://www.daum.net/"abc"'>daum</a>
		<a href="http://www.daum.net/'abc'">daum</a>
		<a href="http://www.daum.net/abc">daum</a>
	</body>
</html>
END

sub show{
	print "@_\n";
}

my $parser = Parse::Token::Simple->new(rules=>\@rules);
$parser->from($html);

$parser->parse;
