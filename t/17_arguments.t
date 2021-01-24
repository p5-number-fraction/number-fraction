use strict;
use warnings;
use Test::More;
use Number::Fraction;

eval "use Test::Exception";
plan skip_all => "'Test::Exception' required for testing 3 arguments options" if $@;

my $frac = undef;

throws_ok { Number::Fraction->new( 1, 2, 5 ) }
  "Revise your code: 3 arguments is a mixed-fraction feature!";

throws_ok { Number::Fraction->new( 3 .. 6 ) }
  "Warning emitted: 'too many arguments will raise an exception'";

done_testing();
