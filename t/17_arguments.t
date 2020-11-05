use strict;
use warnings;
use Test::More;
use Number::Fraction;

eval "use Test::Warn";
plan skip_all => "'Test::Warn' required for testing 3 arguments options" if $@;

my $frac = undef;

# warnings will be omitted for several months
$frac = eval { Number::Fraction->new( 1, 2, 5 ) };
ok($frac == 0.50,
    "new(1, 2, 5) == 0.50 -- Currently only first two arguments being used");
warning_like { Number::Fraction->new( 1, 2, 5 ) }
  {carped => '/3 arguments/'},
  "Warning emitted: '3 arguments will become mixed-fraction'";

$frac = eval { Number::Fraction->new( 3 .. 6 ) };
ok($frac == 0.75, # 3/4
    "new( 3 .. 6) == 0.75 -- Currently only first two arguments being used");
warning_like { Number::Fraction->new( 3 .. 6 ) }
  {carped => '/too many arguments/'},
  "Warning emitted: 'too many arguments will raise an exception'";

done_testing();
