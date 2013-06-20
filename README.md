# NAME

Parse::Token::Simple - Simply parse String into tokens with rules which are similar to Lex.

# VERSION

version 0.001

# SYNOPSIS

	use Parse::Token::Simple;

	my @rules = (
		[ NUMBER => qr/[\d,\.]+/ ],
		[ WORD => qr/\w+/ ],
		[ WHITESPACE => qr/\s+/ ],
		[ NOTMATCH => qr/.*/ ],
	);

	my $parser = Parse::Token::Simple(rules=>\@rules);
	$parser->from("This costs 1,000won.");
	while( ! $parser->eof ){
		my($state_tag, $token) = $parser->nextToken;
		print "$state_tag -->$token<--\n";
	}

# AUTHOR

khs <sng2nara@gmail.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by khs.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
