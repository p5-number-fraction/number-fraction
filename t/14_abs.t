use Test::More tests => 3;
use Number::Fraction ':constants';

my $f = '-1/2';
my $f2 = '1/16';
my $f3 = '2/-1';

is(abs($f), '1/2', 'Abs on a negative numerator');
is(abs($f2), '1/16', 'Abs on a positive fraction');
is(abs($f3), '2/1', 'Abs on a negative denominator');
