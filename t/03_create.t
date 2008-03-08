use Test::More tests => 4;
use Number::Fraction ':constants';

my $f = '1/2';
ok(ref $f eq 'Number::Fraction');
ok($f eq '1/2');

no Number::Fraction;
$f = '1/2';
ok(!ref $f);

use Number::Fraction ':something';
$f = '1/2';
ok(!ref $f);

