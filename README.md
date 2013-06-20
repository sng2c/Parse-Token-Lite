# NAME

Parse::Token::Simple - Simply parse String into tokens with rules which are similar to Lex.

# VERSION

version 0.001

# SYNOPSIS

	use lib './lib';
	use Parse::Token::Simple;

	my @rules = (
		[ NUM => qr/\d[\d,\.]*/ ],
		[ STR => qr/\w+/ ],
		[ SPC => qr/\s+/ ],
		[ ERR => qr/.*/ ],
	);

	my $parser = Parse::Token::Simple->new(rules=>\@rules);
	$parser->from("This costs 1,000won.");
	while( ! $parser->eof ){
		my($state_tag, $token) = $parser->nextToken;
		print "$state_tag -->$token<--\n";
	}

Results are

	STR -->This<--
	SPC --> <--
	STR -->costs<--
	SPC --> <--
	NUM -->1,000<--
	STR -->won<--
	ERR -->.<--

# AUTHOR

khs <sng2nara@gmail.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by khs.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
