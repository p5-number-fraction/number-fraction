# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 1.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test;
BEGIN { plan tests => 13 };
use Number::Fraction ':constants';

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $f = '1/2';
my $f2 = '1/4';

ok($f / $f2 eq '2/1');
ok($f / $f2 == 2);
ok($f / '1/4' eq '2/1');
ok($f / '1/4' == 2);
ok('1/4' / $f eq '1/2');
ok('1/4' / $f == 0.5);
ok('1/2' / '4/8' eq '1/1');
ok('1/2' / '4/8' == 1);
ok($f / 2 == 0.25);
ok($f / 0.5 == 1);
ok(2 / $f == 4);
ok(1.5 / $f == 3);
$f = eval { $f / [] };
ok($@);
