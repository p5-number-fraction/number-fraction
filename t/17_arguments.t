use strict;
use warnings;
use Test::More;
use Number::Fraction;

BEGIN {
  eval "use Test::Exception";
  plan skip_all => "'Test::Exception' required for testing 3 arguments options" if $@;
}

my $frac = undef;

throws_ok { Number::Fraction->new( 1, 2, 5 ) }
  qr/Revise your code: 3 arguments is a mixed-fraction feature!/,
  'Three args throws an error';

throws_ok { Number::Fraction->new( 3 .. 6 ) }
  qr/Revise your code: too many arguments will raise an exception/,
  'Too many args throws an error';

done_testing();
