package Parse::Token::Simple::Rule;
use Moo;

# VERSION
# ABSTRACT: Rule class


=head1 ATTRIBUTES

=head2 name

A name of the rule object. It is called also as 'type' or 'tag'.

=cut

has name=>(is=>'rw');

=head2 re

A regexp to match on text for extract token.

=cut

has re=>(is=>'rw', required=>1);

=head2 func

A callback function for beging executed after re matching.

	sub{
		my ($parser, $token) = @_;
		...
		return @somevalues;
	}

The return values are passed by L<Parse::Token::Simple>::nextToken(), after token object.

=cut

has func=>(is=>'rw');

=head2 state

Describe an array reference of chanined actions for changing a state of a parser.
Actions are invoked when the rule which contains them is matched.

An action begins '+' or '-'.
'+' means start().
'-' means end().

	{ state=>['+INTAG'], ...} # start INTAG; push()
	{ state=>['-INTAG'], ...} # end INTAG; pop()
	{ state=>['+PROP','+PROP_NAME'], ...} # start PROP, start PROP_NAME; push()->push()
	{ state=>['-INTAG','+CONTENT'], ...} # end INTAG, start CONTENT; pop()->push()

=cut
has state=>(is=>'rw');

1;
