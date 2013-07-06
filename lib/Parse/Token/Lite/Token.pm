package Parse::Token::Lite::Token;
use Moo;

# VERSION
# ABSTRACT: Token class

=head1 ATTRIBUTES

=head2 data

returns current matched string.

=cut

has data=>(is=>'rw');

=head2 rule

returns current matched rule.

=cut 

has rule=>(is=>'rw');

sub as_string{
  my ($self) = @_;
  return $self->data;
}


1;
