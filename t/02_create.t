use Test::More tests => 33;
use Number::Fraction;

my $f = Number::Fraction->new('a', 'b');
ok(!ref $f);

$f = Number::Fraction->new(1, 'c');
ok(!ref $f);

$f = eval { Number::Fraction->new([]) };
ok($@);

$f = Number::Fraction->new('1/2');
ok(ref $f eq 'Number::Fraction');
ok($f eq '1/2');
ok($f == 0.5);

$f = Number::Fraction->new(1, 2);
ok(ref $f eq 'Number::Fraction');
ok($f eq '1/2');
ok($f == 0.5);

my $f1 = Number::Fraction->new($f);
ok(ref $f1 eq 'Number::Fraction');
ok($f1 eq '1/2');
ok($f1 == 0.5);

$f1 = Number::Fraction->new;
ok(ref $f1 eq 'Number::Fraction');
ok($f1 eq '0');
ok($f1 == 0);

my $f2 = Number::Fraction->new(4, 8);
ok(ref $f2 eq 'Number::Fraction');
ok($f2 eq '1/2');
ok($f2 == 0.5);

$f2 = Number::Fraction->new('4/8');
ok(ref $f2 eq 'Number::Fraction');
ok($f2 eq '1/2');
ok($f2 == 0.5);

my $f3 = Number::Fraction->new(2, 1);
ok(ref $f3 eq 'Number::Fraction');
ok($f3 eq '2');
ok($f3 == 2);

$f3 = Number::Fraction->new('2/1');
ok(ref $f3 eq 'Number::Fraction');
ok($f3 eq '2');
ok($f3 == 2);

$f3 = Number::Fraction->new(2);
ok(ref $f3 eq 'Number::Fraction');
ok($f3 eq '2');
ok($f3 == 2);

$f3 = Number::Fraction->new('2');
ok(ref $f3 eq 'Number::Fraction');
ok($f3 eq '2');
ok($f3 == 2);
