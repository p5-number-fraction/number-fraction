# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 1.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test;
BEGIN { plan tests => 4 };
use Number::Fraction ':constants';

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $f = '1/2';
ok(ref $f eq 'Number::Fraction');
ok($f eq '1/2');

no Number::Fraction;
$f = '1/2';
ok(!ref $f);

use Number::Fraction ':something';
$f = '1/2';
ok(!ref $f);

