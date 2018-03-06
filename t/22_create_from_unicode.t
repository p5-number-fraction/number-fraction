use strict;
use warnings;
use Test::More;
use Number::Fraction ':constants';

use utf8;

my $f = undef;


$f = '¹²³⁴⁵⁶⁷⁸⁹⁰⁄₁₂₃₄₅₆₇₈₉₀';
cmp_ok ($f, '==',  1.00, "Super- & subscript digits");

$f = '-2⁷⁄₂₀';
cmp_ok ($f, '==', -2.35, "minus two three-twentieths");

$f = '⁷⁄₂₀';
cmp_ok ($f, '==',  0.35, "two three-twentieths");

$f = '-⁷⁄₂₀';
cmp_ok ($f, '==', -0.35, "two three-twentieths negative");

$f = '⁻⁷⁄₂₀';
cmp_ok ($f, '==', -0.35, "two three-twentieths negative superscript");

done_testing();
