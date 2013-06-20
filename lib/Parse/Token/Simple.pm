use strict;
use warnings;
package Parse::Token::Simple;

use Moo;
# VERSION
# ABSTRACT: Simply parse String into tokens with rules which are similar to Lex.

has rules   => ( is=>'rw' );
has data    => ( is=>'rw' );
has state	=> ( is=>'ro', default=>sub{ [] } );
sub from{
	my $self = shift;
	my $data = shift;
    
    $self->data($data);
    
    return 1;
}

sub nextToken{
    my $self = shift;
    foreach my $rule ( @{$self->rules} ){
        my ($tag, $pat, $funcref) = @{$rule};
        my $matched = $self->data =~ m/^$pat/g;
        if( $matched ){
            $self->data($');
			my @funcret;
            if( $funcref ){
                @funcret = ($funcref->($self,$tag,$&));
            }
            return $tag,$&,@funcret;
        }
    }
    die "not matched for first of '".substr($self->data,0,5)."..'";
}

sub eof{
    my $self = shift;
    return length($self->data)?0:1;
}

sub start{
	my $self = shift;
	my $state = shift;
	push(@{$self->state}, $state);
}

sub end{
	my $self = shift;
	my $state = shift;
	return pop(@{$self->state});
}
1;
