package Parse::Token::Simple;
use Moo;
use Data::Dump;
use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($ERROR);

# VERSION
# ABSTRACT: Simply parse String into tokens with rules which are similar to Lex.

=head1 SYNOPSIS

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


=cut

=head1 PROPERTIES

=head2 rulemap

rulemap contains hash refrence of rule objects grouped by STATE.
rulemap should have 'MAIN' item.

	my %rule = (
		MAIN => [
			Parse::Token::Simple::Rule->new(name=>'any', re=>qr/./),
		],
	);
	$parser->rulemap(\%rule);

In constructor, it can be replaced with hash reference descripting attributes of L<Parse::Token::Simple::Rule> class, intead of Rule Object.

	my %rule = (
		MAIN => [
			{name=>'any', re=>qr/./}, # ditto
		],
	);
	my $parser = Parse::Token::Simple->new( rulemap=>\%rule );

=cut

has rulemap => ( is=>'rw', default=>sub{return {};});

=head2 data

'data' is set by from() method.
'data' contains a rest of text which is not processed by nextToken().
Please remember, 'data' is changing.

If a length of 'data' is 0, eof() returns 1.

=cut

has data	=> ( is=>'rwp' );

=head2 state_stack

At first time, it contains ['MAIN'].
It is reset by from().

=cut

has state_stack	=> ( is=>'rwp', default=>sub{['MAIN']} );

sub BUILD{
	my $self = shift;
    my %rulemap;
	foreach my $key (keys %{$self->rulemap}){
        $self->rulemap->{$key} = [map{ Parse::Token::Simple::Rule->new($_) }@{$self->rulemap->{$key}}];
	}
}

=head1 METHODS

=head2 from($data_string)

Setting data to parse.

This causes resetting state_stack.

=cut 

sub from{
	my $self = shift;
	my $data = shift;
	
	$self->_set_data($data);
	$self->_set_state_stack(['MAIN']); # reset state.
	
	return 1;
}

=head2 parse()

Parse all tokens on Event driven.
Just call nextToken() during that eof() is not 1.

You should set a callback function at 'func' attribute in 'rulemap' to do something with tokens.

=cut

sub parse{
	my $self = shift;
	while(!$self->eof){
		$self->nextToken;
	}
}

=head2 currentRules()

Returns an array reference of rules of current state. 

=cut

sub currentRules{
    my $self = shift;
    return $self->rulemap->{$self->state};
}

=head2 nextToken()

=cut

sub nextToken{
	my $self = shift;
 
	foreach my $rule ( @{$self->currentRules} ){
        my $pat = $rule->re;
		my $matched = $self->data =~ m/^$pat/s;
		if( $matched ){
			$self->_set_data($');

		    map{
                if( $_ =~ /([+-])(.+)/ ){
                    if( $1 eq '+' ){
                        $self->start($2);
                    }
                    else{
                        $self->end($2);
                    }
                }
                else{
                    die "invalid state_action '$_'";
                }
            } (@{$rule->state}) if $rule->state;
			
            my $ret = Parse::Token::Simple::Token->new(rule=>$rule,data=>$&);
            
			my @funcret;
			if( $rule->func ){
				@funcret = $rule->func->($self,$ret);
			}

            if( wantarray ){
                return $ret,@funcret;
            }
            else{
                return $ret;
            }
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
	DEBUG ">>> START '$state'";
	push(@{$self->state_stack}, $state);
}

sub end{
	my $self = shift;
	my $state = shift;
	DEBUG "<<< STOP  '$state'";
	return pop(@{$self->state_stack});
}

sub state{
	my $self = shift;
	return '' if( @{$self->state_stack} == 0 );
	return $self->state_stack->[@{$self->state_stack}-1];
}

package Parse::Token::Simple::Rule;
use Moo;
has name=>(is=>'rw');
has re=>(is=>'rw', required=>1);
has func=>(is=>'rw');
has state=>(is=>'rw');

package Parse::Token::Simple::Token;
use Moo;
has data=>(is=>'rw');
has rule=>(is=>'rw');


1;
