# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 1.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test;
BEGIN { plan tests => 11 };
use Number::Fraction ':constants';

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $f = '1/2';
my $f2 = '1/4';

ok($f + $f2 eq '3/4');
ok($f + $f2 == 0.75);
ok($f + '1/4' eq '3/4');
ok($f + '1/4' == 0.75);
ok('1/4' + $f eq '3/4');
ok('1/4' + $f == 0.75);
ok('1/2' + '4/8' eq '1/1');
ok('1/2' + '4/8' == 1);
ok($f + 0.25 == 0.75);
ok($f + 1 == 1.5);
$f = eval { $f + [] };
ok($@);
