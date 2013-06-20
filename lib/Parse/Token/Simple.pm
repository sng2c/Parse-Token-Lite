use strict;
use warnings;
package Parse::Token::Simple;

use Data::Dump;
use Moo;
# VERSION
# ABSTRACT: Simply parse String into tokens with rules which are similar to Lex.

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
		if( $tag =~ /:([^:]*)/ ){
			$state = $`;
			$tag = $1;
			if( $state =~ s/([+-]?)$// ){
				$state_action = $1;
			}
		}
		push(@rulemap,[$state,$state_action,$tag,$pat,$funcref]);
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
		my ($state, $state_action, $tag, $pat, $funcref) = @{$rule};
		my $matched = $self->data =~ m/^$pat/;
		next if( $state ne $self->state && $state_action ne '+' );
		if( $matched ){
			$self->_set_data($');
			my @funcret;
			if( $funcref ){
				@funcret = ($funcref->($self,$tag,$&));
			}
			$self->start($state) if($state_action eq '+');
			$self->end($state) if($state_action eq '-');
			return $state?"$state:$tag":$tag,$&,$state_action,@funcret;
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
	push(@{$self->state_stack}, $state);
}

sub end{
	my $self = shift;
	my $state = shift;
	return pop(@{$self->state_stack});
}

sub state{
	my $self = shift;
	return '' if( @{$self->state_stack} == 0 );
	return $self->state_stack->[@{$self->state_stack}-1];
}
1;
