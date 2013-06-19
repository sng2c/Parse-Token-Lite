use strict;
use warnings;
package Parse::Token::Simple;

use Moo;
# VERSION
# ABSTRACT: Simply parse String into tokens with rules which are similar to Lex.

has rules=> ( is=>'rw' );
has dataref=> ( is=>'rw' );

sub from{
	my $self = shift;
	my $dataref = shift;
	if( ref($dataref) eq '' ){
		$dataref = \$dataref;
	}
	$self->dataref($dataref);
}

sub nextToken{
	
}

sub eof{

}

1;
