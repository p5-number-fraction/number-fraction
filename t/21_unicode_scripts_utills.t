use strict;
use warnings;
use Test::More;
use Number::Fraction ':constants';

use utf8;

my $f = undef;

cmp_ok (Number::Fraction::_sup_to_basic('⁰¹²³⁴⁵⁶⁷⁸⁹⁺⁻⁼⁽⁾'),
  'eq', "0123456789+-=()", "Translate from superscript");

cmp_ok (Number::Fraction::_sub_to_basic('₀₁₂₃₄₅₆₇₈₉₊₋₌₍₎'),
  'eq', "0123456789+-=()", "Translate from subscript");

cmp_ok (Number::Fraction::_basic_to_sup('0123456789+-=()'),
  'eq', "⁰¹²³⁴⁵⁶⁷⁸⁹⁺⁻⁼⁽⁾", "Translate to superscript");

cmp_ok (Number::Fraction::_basic_to_sub('0123456789+-=()'),
  'eq', "₀₁₂₃₄₅₆₇₈₉₊₋₌₍₎", "Translate to subscript");

no Number::Fraction; # prevent contstants to be parsed
{
local $Number::Fraction::MIXED_SEP = "_";

cmp_ok (Number::Fraction::_to_unicode('5/6'),
  'eq', '⁵⁄₆', "Unicode 5/6");

cmp_ok (Number::Fraction::_to_unicode('-5/6'),
  'eq', '⁻⁵⁄₆', "Unicode -5/6");

cmp_ok (Number::Fraction::_to_unicode('1_6/8'),
  'eq', '1⁶⁄₈', "Unicode 1_6/8"); # no normalization here

cmp_ok (Number::Fraction::_to_unicode('-2_7/8'),
  'eq', '-2⁷⁄₈', "Unicode -2_7/8");

cmp_ok (Number::Fraction::_to_unicode('-1'),
  'eq', '-1', "Unicode -1, just a negative integer");
}

done_testing();
