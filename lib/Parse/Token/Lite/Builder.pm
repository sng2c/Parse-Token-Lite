package Parse::Token::Lite::Builder;

use Parse::Token::Lite;
use Carp;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(ruleset on name with match start end);

*_on = sub{ croak 'on'; };
*_name = sub{ croak 'name'; };
*_with = sub{ croak 'with'; };
*_match = sub{ croak 'match'; };
*_start = sub{ croak 'start'; };
*_end = sub{ croak 'end'; };

sub on($&){ goto &_on };
sub name($){ goto &_name };
sub with(&){ goto &_with };
sub match($&){ goto &_match };
sub start($){ goto &_start };
sub end($){ goto &_end };

sub ruleset(&){
	my $rules = {};
	my $code = shift;

	local *_match = sub($&){
		my ($pat, $code) = @_;
		my $_rule = {re=>$pat, state=>[] };
		
		local *_name = sub($){ $_rule->{name} = $_[0]; };
		local *_with = sub(&){ $_rule->{func} = $_[0]; };
		local *_start = sub($){ push(@{$_rule->{state}}, '+'.$_[0]); }; 
		local *_end  = sub($){ push(@{$_rule->{state}}, '-'.$_[0]); }; 

		$code->();
		push(@{$rules->{MAIN}},$_rule);
	};

	local *_on = sub($&){
		my ($state, $code) = @_;

		local *_match = sub($&){
			my ($pat, $code) = @_;
			my $_rule = {re=>$pat, state=>[] };
			
			local *_name = sub($){ $_rule->{name} = $_[0]; };
			local *_with = sub(&){ $_rule->{func} = $_[0]; };
			local *_start = sub($){ push(@{$_rule->{state}}, '+'.$_[0]); }; 
			local *_end  = sub($){ push(@{$_rule->{state}}, '-'.$_[0]); }; 

			$code->();
			push(@{$rules->{$state}},$_rule);
		};

		$code->();
	};

	$code->();

	return $rules;
}
1;
=pod

my $ruleset = ruleset{

	match /123/ => sub{
		name 'BEGIN_NUM';
		with { my ($parser, $token) = @_;

		};
		start 'TEST';
	};



	on 'TEST' => sub{
		match /567/ => sub{
			name 'END_NUM';
			end 'TEST';
		};

		match /./ => sub{
			this_is '4';
			func {
				my ($parser,$token) = @_;
				print $token->data."\n";
			};
		};
	};
};

=cut
