# NAME

Parse::Token::Lite - Simply parse String into tokens with rules which are similar to Lex.

# VERSION

version 0.110

# SYNOPSIS

	use Parse::Token::Lite;

	my %rules = (
		MAIN=>[
			{ name=>'NUM', re=> qr/\d[\d,\.]*/ },
			{ name=>'STR', re=> qr/\w+/ },
			{ name=>'SPC', re=> qr/\s+/ },
			{ name=>'ERR', re=> qr/.*/ },
		],
	);

	my $parser = Parse::Token::Lite->new(rulemap=>\%rules);
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

# ATTRIBUTES

## rulemap

rulemap contains hash refrence of rule objects grouped by STATE.
rulemap should have 'MAIN' item.

	my %rule = (
		MAIN => [
			Parse::Token::Lite::Rule->new(name=>'any', re=>qr/./),
		],
	);
	$parser->rulemap(\%rule);

In constructor, it can be replaced with hash reference descripting attributes of [Parse::Token::Lite::Rule](http://search.cpan.org/perldoc?Parse::Token::Lite::Rule) class, intead of Rule Object.

	my %rule = (
		MAIN => [
			{name=>'any', re=>qr/./}, # ditto
		],
	);
	my $parser = Parse::Token::Lite->new( rulemap=>\%rule );

## data

'data' is set by from() method.
'data' contains a rest of text which is not processed by nextToken().
Please remember, 'data' is changing.

If a length of 'data' is 0, eof() returns 1.

## state\_stack

At first time, it contains \['MAIN'\].
It is reset by from().

# METHODS

## from($data\_string)

Setting data to parse.

This causes resetting state\_stack.

## parse()

## parse($data)

On Scalar context : Returns 1
On Array context : Returns array of \[[Parse::Token::Lite::Token](http://search.cpan.org/perldoc?Parse::Token::Lite::Token),@return\_values\_of\_callback\].

Parse all tokens on Event driven.
Just call nextToken() during that eof() is not 1.

Defined $data causes calling from($data).

You should set a callback function at 'func' attribute in 'rulemap' to do something with tokens.

## currentRules()

Returns an array reference of rules of current state. 

See [Parse::Token::Lite::Rule](http://search.cpan.org/perldoc?Parse::Token::Lite::Rule).

## nextToken()

On Scalar context : Returns [Parse::Token::Lite::Token](http://search.cpan.org/perldoc?Parse::Token::Lite::Token) object.
On Array context : Returns ([Parse::Token::Lite::Token](http://search.cpan.org/perldoc?Parse::Token::Lite::Token),@return\_values\_of\_callback).

	my ($token, @ret) = $parser->nextToken;
	print $token->rule->name . '->' . $token->data . "\n";

See [Parse::Token::Lite::Token](http://search.cpan.org/perldoc?Parse::Token::Lite::Token) and [Parse::Token::Lite::Rule](http://search.cpan.org/perldoc?Parse::Token::Lite::Rule).

## eof()

Returns 1 when no more text is.

## start($state)

## end()

## end($state)

Push/Pop the state on state\_stack to implement AUTOMATA.

Also, this is called by a 'state' definition of [Parse::Token::Lite::Rule](http://search.cpan.org/perldoc?Parse::Token::Lite::Rule).

You can set rules as Lexer like.

	my $rulemap = {
		MAIN => [
			{ name=>'QUOTE', re=>qr/'/, func=>
				sub{ 
					my ($parser,$token) = @_;
					$parser->start('STATE_QUOTE'); # push
				}
			},
			{ name=>'ANY', re=>qr/.+/ },
		],
		STATE_QUOTE => [
			{ name=>'QUOTE_PAIR', re=>qr/'/, func=>
				sub{ 
					my ($parser,$token) = @_;
					$parser->end('STATE_QUOTE'); # pop
				}
			},
			{ name=>'QUOTED_TEXT', re=>qr/.+/ }
		],
	};

You can also do it in simple way.

	my $rulemap = {
		MAIN => [
			{ name=>'QUOTE', re=>qr/'/, state=>['+STATE_QUOTE'] }, # push
			{ name=>'ANY', re=>qr/.+/ },
		],
		STATE_QUOTE => [
			{ name=>'QUOTE_PAIR', re=>qr/'/, state=>['-STATE_QUOTE] }, #pop
			{ name=>'QUOTED_TEXT', re=>qr/.+/ }
		],
	};

## state()

Returns current state by peeking top of 'state\_stack'.

# SEE ALSO

See [Parse::Token::Lite::Token](http://search.cpan.org/perldoc?Parse::Token::Lite::Token) and [Parse::Token::Lite::Rule](http://search.cpan.org/perldoc?Parse::Token::Lite::Rule).

# AUTHOR

khs <sng2nara@gmail.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by khs.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
