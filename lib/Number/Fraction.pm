=head1 NAME

Number::Fraction - Perl extension to model fractions

=head1 SYNOPSIS

  use Number::Fraction;

  my $f1 = Number::Fraction->new(1, 2);
  my $f2 = Number::Fraction->new('1/2');
  my $f3 = Number::Fraction->new($f1); # clone
  my $f4 = Number::Fraction->new; # 0/1

or

  use Number::Fraction ':constants';

  my $f1 = '1/2';
  my $f2 = $f1;

  my $one = $f1 + $f2;
  my $half = $one - $f1;
  print $half; # prints '1/2'

=head1 ABSTRACT

Number::Fraction is a Perl module which allows you to work with fractions
in your Perl programs.

=head1 DESCRIPTION

Number::Fraction allows you to work with fractions (i.e. rational
numbers) in your Perl programs in a very natural way.

It was originally written as a demonstration of the techniques of 
overloading.

If you use the module in your program in the usual way

  use Number::Fraction;

you can then create fraction objects using C<Number::Fraction->new> in
a number of ways.

  my $f1 = Number::Fraction->new(1, 2);

creates a fraction with a numerator of 1 and a denominator of 2.

  my $fm = Number::Fraction->new(1, 2, 3);

creates a fraction from an integer of 1, a numerator of 2 and a denominator
of 3; which results in a fraction of 5/3 since fractions are normalised.

  my $f2 = Number::Fraction->new('1/2');

does the same thing but from a string constant.

  my $f3 = Number::Fraction->new($f1);

makes C<$f3> a copy of C<$f1>

  my $f4 = Number::Fraction->new; # 0/1

creates a fraction with a denominator of 0 and a numerator of 1.

If you use the alterative syntax of

  use Number::Fraction ':constants';

then Number::Fraction will automatically create fraction objects from
string constants in your program. Any time your program contains a 
string constant of the form C<\d+/\d+> then that will be automatically
replaced with the equivalent fraction object. For example

  my $f1 = '1/2';

Having created fraction objects you can manipulate them using most of the
normal mathematical operations.

  my $one = $f1 + $f2;
  my $half = $one - $f1;

Additionally, whenever a fraction object is evaluated in a string
context, it will return a string in the format x/y. When a fraction
object is evaluated in a numerical context, it will return a floating
point representation of its value.

Fraction objects will always "normalise" themselves. That is, if you
create a fraction of '2/4', it will silently be converted to '1/2'.

=head2 Mixed Fractions and Unicode Support

Since version 3.0 the interpretation of strings and constants has been
enriched with a few features for mixed fractions and Unicode characters.

Number::Fraction now recognises a more Perlish way of entering mixed fractions which consist of an integer-part and a fraction in the form of
C<\d+_\d+/\d+>. For example

  my $mixed = '2_3/4'; # two and three fourths, stored as 11/4

or

  my $simple = '2½'; # two and a half, stored as 5/2

Mixed fractions, either in Perl notation or with Unicode fractions can
be negative, prepending it with a minus-sign.

  my $negative = '-⅛'; # minus one eighth

=head2 Experimental Support for Exponentiation

Version 1.13 of Number::Fraction adds experimental support for exponentiation
operations. If a Number::Fraction object is used as the left hand operand of
an exponentiation expression then the value returned will be another
Number::Fraction object - if that makes sense. In all other cases, the
expression returns a real number.

Currently this only works if the right hand operand is an integer (or
a Number::Fraction object that has a denominator of 1). Later I hope to
extend this so support so that a Number::Fraction object is returned
whenever the result of the expression is a rational number.

For example:

  '1/2' ** 2 #   Returns a Number::Fraction ('1/4')
  '2/1' ** '2/1' Returns a Number::Fraction ('4/1')
  '2/1' ** '1/2' Returns a real number (1.414213)
   0.5  ** '2/1' Returns a real number (0.25)

=head2 Version 2: Now With Added Moose

Version 2 of Number::Fraction has been reimplemented using Moose. You should
see very little difference in the way that the class works. The only difference
I can see is that C<new> used to return C<undef> if it couldn't create a valid
object from its arguments, it now dies. If you aren't sure of the values that
are being passed into the constructor, then you'll want to call it within an
C<eval { ... }> block (or using something equivalent like L<Try::Tiny>).

=head1 METHODS

=cut

package Number::Fraction;

use 5.006;
use strict;
use warnings;

use Carp;
use Moose;

our $VERSION = '2.01';

our $_mixed = 0;

use overload
  q("")    => 'to_string',
  '0+'     => 'to_num',
  '+'      => 'add',
  '*'      => 'mult',
  '-'      => 'subtract',
  '/'      => 'div',
  '**'     => 'exp',
  'abs'    => 'abs',
  fallback => 1;

my %_const_handlers = (
  q => sub {
    my $f = eval { __PACKAGE__->new($_[0]) };
    return $_[1] if $@;
    return $f;
  }
);

=head2 import

Called when module is C<use>d. Use to optionally install constant
handler.

=cut

sub import {
    $_mixed = 1 if ( grep { $_ eq ':mixed' } @_ );
    overload::constant %_const_handlers if ( grep { $_ eq ':constants' } @_ );
}

=head2 unimport

Be a good citizen and uninstall constant handler when caller uses
C<no Number::Fraction>.

=cut

sub unimport {
  overload::remove_constant(q => undef);
  $_mixed = undef;
}

has num => (
  is  => 'rw',
  isa => 'Int',
);

has den => (
  is  => 'rw',
  isa => 'Int',
);

=head2 BUILDARGS

Parameter massager for Number::Fraction object. Takes the following kinds of
parameters:

=over 4

=item *

A single Number::Fraction object which is cloned.

=item *

A string in the form 'x/y' where x and y are integers. x is used as the
numerator and y is used as the denominator of the new object.

A string in the form 'a_b/c' where a,b and c are integers.
The numerator will be equal to a*c+b!
and c is used as the denominator of the new object.

=item *

Three integers which are used as the integer, numerator and denominator of the
new object.

In order for this to work in version 2.x,
one needs to enable 'mixed' fractions:

  use Number::Fractions ':mixed';

This will be the default behaviour in version 3.x;
when not enabled in version 2.x it will omit a warning to revise your code. 

=item *

Two integers which are used as the numerator and denominator of the
new object.

=item *

A single integer which is used as the numerator of the the new object.
The denominator is set to 1.

=item *

No arguments, in which case a numerator of 0 and a denominator of 1
are used.

=item Note

As of version 2.1 it no longer allows for an array of four or more integer.
Before then, it would simply pass in the first two integers. Version 2.1 allows
for three integers (when using C<:mixed>) and issues a warning when more then two
parameters are passed.
Starting with version 3, it will die as it is seen as an error to pass invalid input.

=back

Dies if a Number::Fraction object can't be created.

=cut 

our @_vulgar_fractions = (
  {regexp=> qr|^(?<sign>-?)(?<int>[0-9]+)?\N{U+00BC}\z|, num=>1, den=>4},
  {regexp=> qr|^(?<sign>-?)(?<int>[0-9]+)?\N{U+00BD}\z|, num=>1, den=>2},
  {regexp=> qr|^(?<sign>-?)(?<int>[0-9]+)?\N{U+00BE}\z|, num=>3, den=>4},
  {regexp=> qr|^(?<sign>-?)(?<int>[0-9]+)?\N{U+2153}\z|, num=>1, den=>3},
  {regexp=> qr|^(?<sign>-?)(?<int>[0-9]+)?\N{U+2154}\z|, num=>2, den=>3},
  {regexp=> qr|^(?<sign>-?)(?<int>[0-9]+)?\N{U+2155}\z|, num=>1, den=>5},
  {regexp=> qr|^(?<sign>-?)(?<int>[0-9]+)?\N{U+2156}\z|, num=>2, den=>5},
  {regexp=> qr|^(?<sign>-?)(?<int>[0-9]+)?\N{U+2157}\z|, num=>3, den=>5},
  {regexp=> qr|^(?<sign>-?)(?<int>[0-9]+)?\N{U+2158}\z|, num=>4, den=>5},
  {regexp=> qr|^(?<sign>-?)(?<int>[0-9]+)?\N{U+2159}\z|, num=>1, den=>6},
  {regexp=> qr|^(?<sign>-?)(?<int>[0-9]+)?\N{U+215A}\z|, num=>5, den=>6},
  {regexp=> qr|^(?<sign>-?)(?<int>[0-9]+)?\N{U+215B}\z|, num=>1, den=>8},
  {regexp=> qr|^(?<sign>-?)(?<int>[0-9]+)?\N{U+215C}\z|, num=>3, den=>8},
  {regexp=> qr|^(?<sign>-?)(?<int>[0-9]+)?\N{U+215D}\z|, num=>5, den=>8},
  {regexp=> qr|^(?<sign>-?)(?<int>[0-9]+)?\N{U+215E}\z|, num=>7, den=>8},
);

# use charnames ':full';
#
#our @_vulgar_fractions = (
# [qr|^(-?)([0-9]+)?\N{VULGAR FRACTION ONE HALF}\z|,       [1, 2]],
# [qr|^(-?)([0-9]+)?\N{VULGAR FRACTION ONE QUARTER}\z|,    [1, 4]],
# [qr|^(-?)([0-9]+)?\N{VULGAR FRACTION THREE QUARTERS}\z|, [3, 4]],
# [qr|^(-?)([0-9]+)?\N{VULGAR FRACTION ONE EIGHTH}\z|,     [1, 8]],
# [qr|^(-?)([0-9]+)?\N{VULGAR FRACTION THREE EIGHTHS}\z|,  [3, 8]],
# [qr|^(-?)([0-9]+)?\N{VULGAR FRACTION FIVE EIGHTHS}\z|,   [5, 8]],
# [qr|^(-?)([0-9]+)?\N{VULGAR FRACTION SEVEN EIGHTHS}\z|,  [7, 8]],
# [qr|^(-?)([0-9]+)?\N{VULGAR FRACTION ONE THIRD}\z|,      [1, 3]],
# [qr|^(-?)([0-9]+)?\N{VULGAR FRACTION TWO THIRDS}\z|,     [2, 3]],
# [qr|^(-?)([0-9]+)?\N{VULGAR FRACTION ONE SIXTH}\z|,      [1, 6]],
# [qr|^(-?)([0-9]+)?\N{VULGAR FRACTION FIVE SIXTHS}\z|,    [5, 6]],
# [qr|^(-?)([0-9]+)?\N{VULGAR FRACTION ONE FIFTH}\z|,      [1, 5]],
# [qr|^(-?)([0-9]+)?\N{VULGAR FRACTION TWO FIFTHS}\z|,     [2, 5]],
# [qr|^(-?)([0-9]+)?\N{VULGAR FRACTION THREE FIFTHS}\z|,   [3, 5]],
# [qr|^(-?)([0-9]+)?\N{VULGAR FRACTION FOUR FIFTHS}\z|,    [4, 5]],
#; # thank you Getty

around BUILDARGS => sub {
  my $orig = shift;
  my $class = shift;
  if (@_ > 3) {
    carp "Revise your code: too many arguments will raise an exception";
  }
  if (@_ == 3) {
    if ( $_mixed ) {
      die "integer, numerator and denominator need to be integers"
        unless $_[0] =~ /^-?[0-9]+\z/
           and $_[1] =~ /^-?[0-9]+\z/
           and $_[2] =~ /^-?[0-9]+\z/;

      return $class->$orig({ num => $_[0] * $_[2] + $_[1], den => $_[2] });
    }
    else { 
      carp "Revise your code: 3 arguments will become mixed-fraction feature!";
    }
  }
  if (@_ >= 2) {
    die "numerator and denominator both need to be integers"
      unless $_[0] =~ /^-?[0-9]+\z/ and $_[1] =~ /^-?[0-9]+\z/;
    return $class->$orig({ num => $_[0], den => $_[1] });
  } elsif (@_ == 1) {
    if (ref $_[0]) {
      if (UNIVERSAL::isa($_[0], $class)) {
        return $class->$orig({ num => $_[0]->{num}, den => $_[0]->{den} });
      } else {
        die "Can't make a $class from a ", ref $_[0];
      }
    }
    
#   for (@_vulgar_fractions) {
#     if ($_[0] =~ m/$_->[0]/ ) {
#       return $class->$orig({
#           num => (defined $2 ? $2 : 0) * $_->[1]->[1] + $_->[1]->[0],
#           den => ($1 eq '-') ? $_->[1]->[1] * -1 : $_->[1]->[1],
#           }
#       );
#     }
#   }
    
    for (@_vulgar_fractions) {
      if ($_[0] =~ m/$_->{regexp}/ ) {
        return $class->$orig({
            num => (defined $+{int} ? $+{int} : 0) * $_->{den} + $_->{num},
            den => ($+{sign} eq '-') ? $_->{den} * -1 : $_->{den},
            }
        );
      }
    }
        
    if ($_[0] =~ m|^(-?)([0-9]+)[_ ]([0-9]+)/([0-9]+)\z|) { # Allow for space ?
#   if ($_[0] =~ m|^(-?)([0-9]+)_([0-9]+)/([0-9]+)\z|) { # Perl notation
        return $class->$orig({
          num => $2 * $4 + $3,
          den=> ($1 eq '-') ? $4 * -1 : $4}
        );
    } elsif ($_[0] =~ m|^(-?[0-9]+)(?:/(-?[0-9]+))?\z|) {
        return $class->$orig({ num => $1, den => ( defined $2 ? $2 : 1) });
    } else {
        die "Can't make fraction out of $_[0]\n";
    }
  } else {
    return $class->$orig({ num => 0, den => 1 });
  }
};

=head2 BUILD

Object initialiser for Number::Fraction. Ensures that fractions are in a
normalised format.

=cut

sub BUILD {
  my $self = shift;
  die "Denominator can't be equal to zero" if $self->{den} == 0;
  $self->_normalise;
}

sub _normalise {
  my $self = shift;

  my $hcf = _hcf($self->{num}, $self->{den});

  for (qw/num den/) {
    $self->{$_} /= $hcf;
  }

  if ($self->{den} < 0) {
    for (qw/num den/) {
      $self->{$_} *= -1;
    }
  }
}

=head2 to_string

Returns a string representation of the fraction in the form
"numerator/denominator".

=cut

sub to_string {
  my $self = shift;

  if ($self->{den} == 1) {
    return $self->{num};
  } else {
    return "$self->{num}/$self->{den}";
  }
}

=head2 to_num

Returns a numeric representation of the fraction by calculating the sum
numerator/denominator. Normal caveats about the precision of floating
point numbers apply.

=cut

sub to_num {
  my $self = shift;

  return $self->{num} / $self->{den};
}

=head2 add

Add a value to a fraction object and return a new object representing the
result of the calculation.

The first parameter is a fraction object. The second parameter is either
another fraction object or a number.

=cut

sub add {
  my ($l, $r, $rev) = @_;

  if (ref $r) {
    if (UNIVERSAL::isa($r, ref $l)) {
      return (ref $l)->new($l->{num} * $r->{den} + $r->{num} * $l->{den},
                           $r->{den} * $l->{den});
    } else {
      croak "Can't add a ", ref $l, " to a ", ref $l;
    }
  } else {
    if ($r =~ /^[-+]?\d+$/) {
      return $l + (ref $l)->new($r, 1);
    } else {
      return $l->to_num + $r;
    }
  }
}

=head2 mult

Multiply a fraction object by a value and return a new object representing
the result of the calculation.

The first parameter is a fraction object. The second parameter is either
another fraction object or a number.

=cut

sub mult {
  my ($l, $r, $rev) = @_;

  if (ref $r) {
    if (UNIVERSAL::isa($r, ref $l)) {
      return (ref $l)->new($l->{num} * $r->{num},
                           $l->{den} * $r->{den});
    } else {
      croak "Can't multiply a ", ref $l, " by a ", ref $l;
    }
  } else {
    if ($r =~ /^[-+]?\d+$/) {
      return $l * (ref $l)->new($r, 1);
    } else {
      return $l->to_num * $r;
    }
  }
}

=head2 subtract

Subtract a value from a fraction object and return a new object representing
the result of the calculation.

The first parameter is a fraction object. The second parameter is either
another fraction object or a number.

=cut

sub subtract {
  my ($l, $r, $rev) = @_;

  if (ref $r) {
    if (UNIVERSAL::isa($r, ref $l)) {
      return (ref $l)->new($l->{num} * $r->{den} - $r->{num} * $l->{den},
                           $r->{den} * $l->{den});
    } else {
      croak "Can't subtract a ", ref $l, " from a ", ref $l;
    }
  } else {
    if ($r =~ /^[-+]?\d+$/) {
      $r = (ref $l)->new($r, 1);
      return $rev ? $r - $l : $l - $r;
    } else {
      return $rev ? $r - $l->to_num : $l->to_num - $r;
    }
  }
}

=head2 div

Divide a fraction object by a value and return a new object representing
the result of the calculation.

The first parameter is a fraction object. The second parameter is either
another fraction object or a number.

=cut

sub div {
  my ($l, $r, $rev) = @_;

  if (ref $r) {
    if (UNIVERSAL::isa($r, ref $l)) {
      die "FATAL ERROR: Division by zero" if $r->{num} == 0;
      return (ref $l)->new($l->{num} * $r->{den},
                           $l->{den} * $r->{num});
    } else {
      croak "Can't divide a ", ref $l, " by a ", ref $l;
    }
  } else {
    if ($r =~ /^[-+]?\d+$/) {
      $r = (ref $l)->new($r, 1);
      return $rev ? $r / $l : $l / $r;
    } else {
      return $rev ? $r / $l->to_num : $l->to_num / $r;
    }
  }
}

=head2 exp

Raise a Number::Fraction object to a power.

The first argument is a number fraction object. The second argument is
another Number::Fraction object or a number. If the second argument is
an integer or a Number::Fraction object containing an integer then the
value returned is a Number::Fraction object, otherwise the value returned
is a real number.

=cut

sub exp {
  my ($l, $r, $rev) = @_;

  if ($rev) {
    return $r ** $l->to_num;
  }  

  if (UNIVERSAL::isa($r, ref $l)) {
    if ($r->{den} == 1) {
      return $l ** $r->to_num;
    } else {
      return $l->to_num ** $r->to_num;
    }
  } elsif ($r =~ /^[-+]?\d+$/) {
    return (ref $l)->new($l->{num} ** $r, $l->{den} ** $r);
  } else {
    croak "Can't raise $l to the power $r\n";
  }
}

=head2 abs

Returns a copy of the given object with both the numerator and
denominator changed to positive values.

=cut

sub abs {
  my $self = shift;

  return (ref $self)->new(abs($self->{num}), abs($self->{den}));
}

sub _hcf {
  my ($x, $y) = @_;

  ($x, $y) = ($y, $x) if $y > $x;

  return $x if $x == $y;

  while ($y) {
    ($x, $y) = ($y, $x % $y);
  }

  return $x;
}

__PACKAGE__->meta->make_immutable;

1;
__END__

=head2 EXPORT

None by default.

=head1 SEE ALSO

perldoc overload

=head1 AUTHOR

Dave Cross, E<lt>dave@mag-sol.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2002-8 by Dave Cross

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

