use strict;
use warnings;
use Test::More;
use Number::Fraction ':constants';

use utf8;

my $f = undef;

$f = '½';
cmp_ok ($f, '==', 1 / 2, "VULGAR FRACTION ONE HALF");

$f = '¼';
cmp_ok ($f, '==', 1 / 4, "VULGAR FRACTION ONE QUARTER");

$f = '¾';
cmp_ok ($f, '==', 3 / 4, "VULGAR FRACTION THREE QUARTERS");

$f = '⅛';
cmp_ok ($f, '==', 1 / 8, "VULGAR FRACTION ONE EIGHTH");

$f = '⅜';
cmp_ok ($f, '==', 3 / 8, "VULGAR FRACTION THREE EIGHTHS");

$f = '⅝';
cmp_ok ($f, '==', 5 / 8, "VULGAR FRACTION FIVE EIGHTHS");

$f = '⅞';
cmp_ok ($f, '==', 7 / 8, "VULGAR FRACTION SEVEN EIGHTHS");

$f = '⅓';
cmp_ok ($f, '==', 1 / 3 , "VULGAR FRACTION ONE THIRD");

$f = '⅔';
cmp_ok ($f, '==', 2 / 3, "VULGAR FRACTION TWO THIRDS");

$f = '⅙';
cmp_ok ($f, '==', 1 / 6, "VULGAR FRACTION ONE SIXTH");

$f = '⅚';
cmp_ok ($f, '==', 5 / 6, "VULGAR FRACTION FIVE SIXTHS");

$f = '⅕';
cmp_ok ($f, '==', 1 / 5, "VULGAR FRACTION ONE FIFTH");

$f = '⅖';
cmp_ok ($f, '==', 2 / 5, "VULGAR FRACTION TWO FIFTHS");

$f = '⅗';
cmp_ok ($f, '==', 3 / 5, "VULGAR FRACTION THREE FIFTHS");

$f = '⅘';
cmp_ok ($f, '==', 4 / 5, "VULGAR FRACTION FOUR FIFTHS");

$f = '⅐';
cmp_ok ($f, '==', 1 / 7, "VULGAR FRACTION ONE SEVENTH");

$f = '⅑';
cmp_ok ($f, '==', 1 / 9, "VULGAR FRACTION ONE NINTH");

$f = '⅒';
cmp_ok ($f, '==', 1 / 10, "VULGAR FRACTION ONE TENTH");

done_testing();
