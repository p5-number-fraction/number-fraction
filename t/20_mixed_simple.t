use strict;
use warnings;
use Test::More;
use Number::Fraction ':constants';

use utf8;

my $f = undef;

$f = Number::Fraction->new('1/2');
cmp_ok(ref $f, 'eq', 'Number::Fraction', 'String: 1/2');
cmp_ok($f, 'eq', '1/2', '... as a string');
cmp_ok($f, '==', 0.5, '... as a number');

$f = Number::Fraction->new('1_1/2');
cmp_ok ($f, '==', 1.50, "new('1_1/2') == 1.5");
cmp_ok ($f, 'eq', '3/2', "same as 3/2, we do not do mixed out");

$f = Number::Fraction->new('-5_3/4');
cmp_ok ($f, '==', -5.75, "new('-5_3/4') == -5.75");
cmp_ok ($f, 'eq', '-23/4', "same as -23/4, we do not do mixed out");

$f = '2_1/2' + '7_1/3';
cmp_ok ($f, 'eq', '9_5/6', "compile time constant interpolation");

$f = Number::Fraction->new('2¼');
cmp_ok ($f, '==', 2.25, "new('2¼')");

$f = Number::Fraction->new('-2¼');
cmp_ok ($f, '==', -2.25, "new('-2¼')");

$f = Number::Fraction->new('1⅕');
cmp_ok ($f, '==', 1.20, "new('1⅕')");

$f = Number::Fraction->new('3½');
cmp_ok ($f, '==', 3.50, "three and a half");

$f = '½';
cmp_ok ($f, '==', 0.50, "just a half");

$f = '-2½';
cmp_ok ($f, '==', -2.50, "minus two and a half");

$f = '-½';
cmp_ok ($f, '==', -0.50, "just minus a half");

done_testing();
