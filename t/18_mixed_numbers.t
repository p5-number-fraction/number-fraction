use Test::More 'no_plan';
use Number::Fraction ':mixed';

eval "use Test::Warn";
plan skip_all => "'Test::Warn' required for testing 3 arguments options" if $@;

use Test::Warn;

# checking on $@ is useless to see if warnings are omitted
# warnings are not counted as errors, thus eval exits with '0'

my $frac = undef;

$frac = eval { Number::Fraction->new( 1, 2, 5 ) };
ok($frac = 1.40, # 1 + 2/5
    "new(1, 2, 5) = 1.40 -- 1 + 2/5");

$frac = eval { Number::Fraction->new( 3 .. 6 ) };
ok($frac != 3.80, # 3 + 4/5
    "new( 3 .. 6) != 3.80 -- this will never be evaluated, it's bad");
warning_like { Number::Fraction->new( 3 .. 6 ) } 
  {carped => '/too many arguments/'},
  "Warning omited: 'too many arguments will raise an exception'";
