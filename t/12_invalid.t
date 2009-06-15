use Test::More 'no_plan';
use Number::Fraction;

my $f = Number::Fraction->new("\x{555}");
ok(!$f);

$f = Number::Fraction->new("\x{666}");
ok(!$f);

$f = Number::Fraction->new("6\n");
ok(!$f);

$f = Number::Fraction->new("6\n\n");
ok(!$f);
