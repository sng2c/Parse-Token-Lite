# NAME

Parse::Token::Simple - Simply parse String into tokens with rules which are similar to Lex.

# VERSION

version 0.001

# SYNOPSIS

	use Parse::Token::Simple;

	my %rules = (
		MAIN=>[
			{ name=>'NUM', re=> qr/\d[\d,\.]*/ },
			{ name=>'STR', re=> qr/\w+/ },
			{ name=>'SPC', re=> qr/\s+/ },
			{ name=>'ERR', re=> qr/.*/ },
		],
	);

	my $parser = Parse::Token::Simple->new(rulemap=>\%rules);
	$parser->from("This costs 1,000won.");
	while( ! $parser->eof ){
		my ($token,@extra) = $parser->nextToken;
		print $token->rule->name."-->".$token->data."<--\n";
	}

Results are

	STR -->This<--
	SPC --> <--
	STR -->costs<--
	SPC --> <--
	NUM -->1,000<--
	STR -->won<--
	ERR -->.<--

# PROPERTIES

## rulemap

rulemap contains hash refrence of rule objects grouped by STATE.
rulemap should have 'MAIN' item.

	my %rule = (
		MAIN => [
			Parse::Token::Simple::Rule->new(name=>'any', re=>qr/./),
		],
	);
	$parser->rulemap(\%rule);

In constructor, it can be replaced with hash reference descripting attributes of [Parse::Token::Simple::Rule](http://search.cpan.org/perldoc?Parse::Token::Simple::Rule) class, intead of Rule Object.

	my %rule = (
		MAIN => [
			{name=>'any', re=>qr/./}, # ditto
		],
	);
	my $parser = Parse::Token::Simple->new( rulemap=>\%rule );

## data

'data' is set by from() method.
'data' contains a rest of text which is not processed by nextToken().
Please remember, 'data' is changing.

If a length of 'data' is 0, eof() returns 1.

## state\_stack

At first time, it contains \['MAIN'\].
It is reset by from().

# AUTHOR

khs <sng2nara@gmail.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by khs.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
