# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 1.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test;
BEGIN { plan tests => 33 };
use Number::Fraction;

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

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
