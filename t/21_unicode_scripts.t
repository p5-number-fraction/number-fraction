use Test::More tests => 3;
use Number::Fraction ':constants';

use utf8;

my $f = undef;

$f = Number::Fraction::_sup_to_basic('⁰¹²³⁴⁵⁶⁷⁸⁹⁺⁻⁼⁽⁾');
cmp_ok ($f, 'eq', "+-=()0123456789", "Translate from superscript");

$f = Number::Fraction::_sub_to_basic('₀₁₂₃₄₅₆₇₈₉₊₋₌₍₎');
cmp_ok ($f, 'eq', "+-=()0123456789", "Translate from subscript");

$f = '¹²³⁴⁵⁶⁷⁸⁹⁰⁄₁₂₃₄₅₆₇₈₉₀';
cmp_ok ($f, '==', 1, "Super- & subscript digits");

