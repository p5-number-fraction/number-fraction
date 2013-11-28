use Test::More;
use Number::Fraction;

eval "use Test::Warn";
plan skip_all => "'Test::Warn' required for testing 3 arguments options" if $@;

use Test::Warn;

# checking on $@ is useless to see if warnings are omitted
# warnings are not counted as errors, thus eval exits with '0'


my $frac = undef;

# warnings will be omitted for several months
$frac = eval { Number::Fraction->new( 1, 2, 5 ) };
ok($frac == 0.50,
    "new(1, 2, 5) == 0.50 -- Currently only first two arguments being used");

warning_like { Number::Fraction->new( 1, 2, 5 ) } 
  {carped => '/3 arguments/'},
  "Warning omited: '3 arguments will become mixed-fraction'";

$frac = eval { Number::Fraction->new( 3 .. 6 ) };
ok($frac == 0.75, # 3/4
    "new( 3 .. 6) == 0.75 -- Currently only first two arguments being used");

warning_like { Number::Fraction->new( 3 .. 6 ) } 
  {carped => '/too many arguments/'},
  "Warning omited: 'too many arguments will raise an exception'";

# future releases
$frac = eval { Number::Fraction->new( 1, 2, 5 ) };
ok($frac != 1.40, # 1 + 2/5
    "new(1, 2, 5) != 1.40 -- Currently only first two arguments being used");

warning_like { Number::Fraction->new( 1, 2, 5 ) } 
  {carped => '/^(?!.*not implemented yet).*$/'},
  "Warning omited: 'mixed fractions not implemented yet'";

$frac = eval { Number::Fraction->new( 3 .. 6 ) };
ok($frac != 3.80, # 3 + 4/5
    "new( 3 .. 6) != 3.80 -- Currently only first two arguments being used");

warning_like { Number::Fraction->new( 3 .. 6 ) } 
  {carped => '/too many arguments/'},
  "Warning omited: 'too many arguments will raise an exception'";

