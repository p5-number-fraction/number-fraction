#
# DESCRIPTION:
#  Number::Fraction is a Perl object that implements rational numbers.
#
# AUTHOR
#  Dave Cross <dave@dave.org.uk>
#
# COPYRIGHT
#   Copyright (C) 2003, Magnum Solutions Ltd.  All Rights Reserved.
#
#   This script is free software; you can redistribute it and/or
#   modify it under the same terms as Perl itself.
#
# $Id$
#
# $Log$
# Revision 1.5  2004/05/22 21:15:10  dave
# Added more tests.
# Fixed a couple of bugs that they uncovered.
#
# Revision 1.4  2004/04/28 08:37:39  dave
# Added negative tests to MANIFEST
#
# Revision 1.3  2004/04/27 13:12:48  dave
# Added support for negative numbers.
#
# Revision 1.2  2003/02/19 20:01:25  dave
# Correct '+0' to '0+'.
# Added "fallback" - which allowed me to remove cmp and ncmp.
#
#

package Number::Fraction;

use 5.006;
use strict;
use warnings;

use Carp;

our $VERSION = sprintf "%d.%02d", '$Revision$ ' =~ /(\d+)\.(\d+)/;

use overload
  q("") => 'to_string',
  '0+' => 'to_num',
  '+' => 'add',
  '*' => 'mult',
  '-' => 'subtract',
  '/' => 'div',
  fallback => 1;

my %_const_handlers =
  (q => sub { return __PACKAGE__->new($_[0]) || $_[1] });

sub import {
  overload::constant %_const_handlers if $_[1] and $_[1] eq ':constants';
}

sub unimport {
  overload::remove_constant(q => undef);
}

sub new {
  my $class = shift;

  my $self;
  if (@_ >= 2) {
    return unless $_[0] =~ /^-?\d+$/ and $_[1] =~ /^-?\d+$/;

    $self->{num} = $_[0];
    $self->{den} = $_[1];
  } elsif (@_ == 1) {
    if (ref $_[0]) {
      if (UNIVERSAL::isa($_[0], $class)) {
        return $class->new($_[0]->{num},
                           $_[0]->{den});
      } else {
        croak "Can't make a $class from a ", 
          ref $_[0];
	}
    } else {
      return unless $_[0] =~ m|^(-?\d+)/(-?\d+)|;

      $self->{num} = $1;
      $self->{den} = $2;
    }
  } else {
    $self->{num} = 0;
    $self->{den} = 1;
  }

  bless $self, $class;

  $self->normalise;

  return $self;
}

sub normalise {
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

sub to_string {
  my $self = shift;

  return "$self->{num}/$self->{den}";
}

sub to_num {
  my $self = shift;

  return $self->{num} / $self->{den};
}

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

sub div {
  my ($l, $r, $rev) = @_;

  if (ref $r) {
    if (UNIVERSAL::isa($r, ref $l)) {
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

sub _hcf {
  my ($x, $y) = @_;

  ($x, $y) = ($y, $x) if $y > $x;

  return $x if $x == $y;

  while ($y) {
    ($x, $y) = ($y, $x % $y);
  }

  return $x;
}

1;
__END__

=head1 NAME

Number::Fraction - Perl extension to model fractions

=head1 SYNOPSIS

  use Number::Fraction;

  my $f1 = Number::Fraction->new(1, 2);
  my $f2 = Number::Fraction->new('1/2');
  my $f3 = Number::Fraction->new($f1); # clone
  my $f4 = Number::Fraction->new; # 0/1

or

  use Number::Fraction ':constants'

  my $f1 = '1/2';

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

=head2 EXPORT

None by default.



=head1 SEE ALSO

perldoc overload

=head1 AUTHOR

Dave Cross, E<lt>dave@dave.org.ukE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2002 by Dave Cross

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
