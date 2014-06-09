use Test::More tests => 8;
use Number::Fraction ':constants';

use utf8;

my $f = undef;

$f = Number::Fraction::_sup_to_basic('⁰¹²³⁴⁵⁶⁷⁸⁹⁺⁻⁼⁽⁾');
cmp_ok ($f, 'eq', "0123456789+-=()", "Translate from superscript");

$f = Number::Fraction::_sub_to_basic('₀₁₂₃₄₅₆₇₈₉₊₋₌₍₎');
cmp_ok ($f, 'eq', "0123456789+-=()", "Translate from subscript");

$f = '¹²³⁴⁵⁶⁷⁸⁹⁰⁄₁₂₃₄₅₆₇₈₉₀';
cmp_ok ($f, '==', 1, "Super- & subscript digits");

$f = '-2³⁄₂₀';
cmp_ok ($f, '==', -2.15, "minus two three-twentieths");

no Number::Fraction; # Make sure we do not parse constants in 'eq' tests

cmp_ok ($f->to_mixed, 'eq', '-2_3/20', "to mixed");

cmp_ok (Number::Fraction->new('-5/7')->to_mixed, 'eq', '-5/7', "nothing mixed");

cmp_ok (Number::Fraction->new('8/4')->to_mixed, 'eq', '2', "just an integer");

cmp_ok (Number::Fraction->new('0/1')->to_mixed, 'eq', '0', "mixed zero, uhm");

