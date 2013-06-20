use strict;
use warnings;
package Parse::Token::Simple;

use Data::Dump;
use Moo;
# VERSION
# ABSTRACT: Simply parse String into tokens with rules which are similar to Lex.

=head1 SYNOPSIS

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


=cut

has rules   => ( is=>'ro', writer=>'set_rules' , required=>1);
has rulemap => ( is=>'rwp' );
has data	=> ( is=>'rwp' );
has state_stack	=> ( is=>'rwp', default=>sub{[]} );

sub BUILD{
	my $self = shift;
	my @rulemap;
	foreach my $rule (@{$self->rules}){
		my ($tag, $pat, $funcref) = @{$rule};
		my $state = '';
		my $state_action = '';

		if( $tag =~ /(.+):(.*)([<>].+)/ ){
			$state = $1;
			$tag = $2;
			$state_action = $3;
		}
		elsif( $tag =~ /([<>].+)/){
			$state_action = $tag;
			$tag = '';
		}
		elsif( $tag =~ /(.+):(.*)/ ){
			$state = $1;
			$tag = $2;
		}
		#dd "state:$state, tag:$tag, action:$state_action";
		push(@rulemap,[$state,$tag,$state_action,$pat,$funcref]);
	}
	$self->_set_rulemap(\@rulemap);
}

sub from{
	my $self = shift;
	my $data = shift;
	
	$self->_set_data($data);
	
	return 1;
}

sub nextToken{
	my $self = shift;
	foreach my $rule ( @{$self->rulemap} ){
		my ($state, $tag, $state_action, $pat, $funcref) = @{$rule};
		next if( $state ne $self->state );
		#dd "LOOP $state $tag $state_action";
		my $matched = $self->data =~ m/^$pat/;
		if( $matched ){
			$self->_set_data($');

			if( $state_action ){
				if( $state_action =~ /([<>])(.+)/ ){
					my $target_action = $1;
					my $target_state = $2;
					$self->start($target_state) if($target_action eq '>');
					$self->end($target_state) if($target_action eq '<');
				}
			}

			my @state = ($tag);
			unshift(@state,$state) if( $state );
			my $state_tag = join(':',@state);
			my @funcret;
			if( $funcref ){
				@funcret = ($funcref->($self,$state_tag,$&,$state_action));
			}
			return $state_tag,$&,$state_action,@funcret;
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
	#dd ">>> START $state";
	push(@{$self->state_stack}, $state);
}

sub end{
	my $self = shift;
	my $state = shift;
	#dd "<<< STOP  $state";
	return pop(@{$self->state_stack});
}

sub state{
	my $self = shift;
	return '' if( @{$self->state_stack} == 0 );
	return $self->state_stack->[@{$self->state_stack}-1];
}
1;
