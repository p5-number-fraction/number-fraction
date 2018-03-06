use strict;
use warnings;
use Test::More;
use Number::Fraction ':constants';

use utf8;

my $f = undef;

no Number::Fraction; # Make sure we do not parse constants in 'eq' tests

# to_mixed
{
local $Number::Fraction::MIXED_SEP = "_";

cmp_ok (Number::Fraction->new(7, 3)->to_mixed,
  'eq', '2_1/3',    "mixed from two integers");
cmp_ok (Number::Fraction->new(-16, 12)->to_mixed,
  'eq', '-1_1/3',   "mixed from two integers with negatives");
cmp_ok (Number::Fraction->new('-2³⁄₂₀')->to_mixed,
  'eq', '-2_3/20',  "mixed from a mixed scripted fraction");
cmp_ok (Number::Fraction->new('2¾')->to_mixed,
  'eq', '2_3/4',    "mixed from a mixed simple fraction");
cmp_ok (Number::Fraction->new('-5/7')->to_mixed,
  'eq', '-5/7',     "nothing mixed");
cmp_ok (Number::Fraction->new('8/4')->to_mixed,
  'eq', '2',        "just an integer");
cmp_ok (Number::Fraction->new('0/1')->to_mixed,
  'eq', '0',        "mixed zero, uhm");

}
# to_unicode_string

cmp_ok (Number::Fraction->new(7, 3)->to_unicode_string,
  'eq', '⁷⁄₃',    "unicode string from two integers");
cmp_ok (Number::Fraction->new(-16, 12)->to_unicode_string,
  'eq', '⁻⁴⁄₃',   "unicode string from two integers with negatives");
cmp_ok (Number::Fraction->new('-2³⁄₂₀')->to_unicode_string,
  'eq', '⁻⁴³⁄₂₀',  "unicode string from a mixed scripted fraction");
cmp_ok (Number::Fraction->new('2¾')->to_unicode_string,
  'eq', '¹¹⁄₄',    "unicode string from a mixed simple fraction");
cmp_ok (Number::Fraction->new('-5/7')->to_unicode_string,
  'eq', '⁻⁵⁄₇',     "nothing mixed");
cmp_ok (Number::Fraction->new('8/4')->to_unicode_string,
  'eq', '2',        "just an integer");
cmp_ok (Number::Fraction->new('0/1')->to_unicode_string,
  'eq', '0',        "unicode string zero, uhm");

# to_unicode_mixed

cmp_ok (Number::Fraction->new(7, 3)->to_unicode_mixed,
  'eq', '2¹⁄₃',    "unicode mixed from two integers");
cmp_ok (Number::Fraction->new(-16, 12)->to_unicode_mixed,
  'eq', '-1¹⁄₃',   "unicode mixed from two integers with negatives");
cmp_ok (Number::Fraction->new('-2³⁄₂₀')->to_unicode_mixed,
  'eq', '-2³⁄₂₀',  "unicode mixed from a mixed scripted fraction");
cmp_ok (Number::Fraction->new('2¾')->to_unicode_mixed,
  'eq', '2³⁄₄',    "unicode mixed from a mixed simple fraction");
cmp_ok (Number::Fraction->new('-5/7')->to_unicode_mixed,
  'eq', '⁻⁵⁄₇',     "unicode nothing mixed");
cmp_ok (Number::Fraction->new('8/4')->to_unicode_mixed,
  'eq', '2',        "unicode just an integer");
cmp_ok (Number::Fraction->new('0/1')->to_unicode_mixed,
  'eq', '0',        "unicode mixed zero, uhm");

# to_simple

cmp_ok (Number::Fraction->new(7, 3)->to_simple,
  'eq', '2⅓',    "simple mixed from two integers");
cmp_ok (Number::Fraction->new(-16, 12)->to_simple,
  'eq', '-1⅓',   "simple mixed from two integers with negatives");
cmp_ok (Number::Fraction->new('-2³⁄₂₀')->to_simple,
  'eq', '-2⅙',  "nearest simple mixed from a mixed scripted fraction");
cmp_ok (Number::Fraction->new('2¾')->to_simple,
  'eq', '2¾',    "simple mixed from a mixed simple fraction");
cmp_ok (Number::Fraction->new('-5/7')->to_simple(7),
  'eq', '⁻⁵⁄₇',     "no simple nothing mixed");
cmp_ok (Number::Fraction->new('8/4')->to_simple,
  'eq', '2',        "simple just an integer");
cmp_ok (Number::Fraction->new('0/1')->to_simple,
  'eq', '0',        "simple mixed zero, uhm");

done_testing();
