# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 1.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test;
BEGIN { plan tests => 48 };
use Number::Fraction ':constants';

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $f = '1/2';
my $f2 = '1/4';

ok($f > $f2);
ok($f >= $f2);
ok(!($f < $f2));
ok(!($f <= $f2));
ok($f != $f2);
ok(!($f == $f2));

ok('1/2' > $f2);
ok('1/2' >= $f2);
ok(!('1/2' < $f2));
ok(!('1/2' <= $f2));
ok('1/2' != $f2);
ok(!('1/2' == $f2));

ok($f > '1/4');
ok($f > '1/4');
ok($f >= '1/4');
ok(!($f < '1/4'));
ok(!($f <= '1/4'));
ok($f != '1/4');

ok('1/2' > $f2);
ok('1/2' > '1/4');
ok('1/2' >= '1/4');
ok(!('1/2' < '1/4'));
ok(!('1/2' <= '1/4'));
ok('1/2' != '1/4');

ok(!($f gt $f2));
ok(!($f ge $f2));
ok($f lt $f2);
ok($f le $f2);
ok($f ne $f2);
ok(!($f eq $f2));

ok(!('1/2' gt $f2));
ok(!('1/2' ge $f2));
ok('1/2' lt $f2);
ok('1/2' le $f2);
ok('1/2' ne $f2);
ok(!('1/2' eq $f2));

ok(!($f gt '1/4'));
ok(!($f ge '1/4'));
ok($f lt '1/4');
ok($f le '1/4');
ok($f ne '1/4');
ok(!($f eq '1/4'));

ok(!('1/2' gt '1/4'));
ok(!('1/2' ge '1/4'));
ok('1/2' lt '1/4');
ok('1/2' le '1/4');
ok('1/2' ne '1/4');
ok(!('1/2' eq '1/4'));
