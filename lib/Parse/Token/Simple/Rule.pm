package Parse::Token::Simple::Rule;
use Moo;
has name=>(is=>'rw');
has re=>(is=>'rw', required=>1);
has func=>(is=>'rw');
has state=>(is=>'rw');

# VERSION
# ABSTRACT: Rule class

1;
