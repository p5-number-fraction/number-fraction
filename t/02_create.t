# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 1.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test;
BEGIN { plan tests => 18 };
use Number::Fraction;

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $f = Number::Fraction->new('1/2');
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
ok($f1 eq '0/1');
ok($f1 == 0);

my $f2 = Number::Fraction->new(4, 8);
ok(ref $f eq 'Number::Fraction');
ok($f eq '1/2');
ok($f == 0.5);

$f2 = Number::Fraction->new('4/8');
ok(ref $f eq 'Number::Fraction');
ok($f eq '1/2');
ok($f == 0.5);
