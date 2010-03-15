use Test::More tests => 4;
use Number::Fraction ':constants';

my $f = '1/2';
my $f2 = '1/16';

is($f ** 2, 0.25);
is($f ** 3, 0.125);
is(4 ** $f, 2);
is($f2 ** $f, 0.25);
