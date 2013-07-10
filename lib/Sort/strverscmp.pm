use strict;
use warnings;

package Sort::strverscmp;

use Exporter 'import';
our @EXPORT = qw(strverscmp);
our @EXPORT_OK = qw(strverssort);

use feature ':5.10';

use constant SX => 0;
use constant FX => 1;
use constant IX => 2;
use constant YX => 3;
use constant S => qr/^[^\d\-_.]+/;
use constant F => qr/^0\d+/;
use constant I => qr/^\d+/;
use constant Y => qr/^[\-_.]/;

sub type {
    my $in = shift;

    state $S = S;
    state $F = F;
    state $I = I;
    state $Y = Y;

    for ($in) {
        when (/($S)$/) { return SX }
        when (/($F)$/) { return FX } # must test F before I
        when (/($I)$/) { return IX }
        when (/($Y)$/) { return YX }
        default { die sprintf(q(unknown type: %s), $in) }
    }
}

sub select_cmp {
    my ($l, $r) = @_;

    state $cmp;
    unless ($cmp) {
        $cmp = [];
        $cmp->[SX][SX] = sub { my ($a, $b) = @_; $a cmp $b };
        $cmp->[SX][FX] = sub {  1 };
        $cmp->[SX][IX] = sub {  1 };
        $cmp->[SX][YX] = sub { my ($a, $b) = @_; $a cmp $b };
        $cmp->[FX][SX] = sub { -1 };
        $cmp->[FX][FX] = sub { my ($a, $b) = @_; $a <=> $b };
        $cmp->[FX][IX] = sub { -1 };
        $cmp->[FX][YX] = sub { my ($a, $b) = @_; $a cmp $b };
        $cmp->[IX][SX] = sub { -1 };
        $cmp->[IX][FX] = sub {  1 };
        $cmp->[IX][IX] = sub { my ($a, $b) = @_; $a <=> $b };
        $cmp->[IX][YX] = sub { my ($a, $b) = @_; $a cmp $b };
        $cmp->[YX][SX] = sub { my ($a, $b) = @_; $a cmp $b };
        $cmp->[YX][FX] = sub { my ($a, $b) = @_; $a cmp $b };
        $cmp->[YX][IX] = sub { my ($a, $b) = @_; $a cmp $b };
        $cmp->[YX][YX] = sub { my ($a, $b) = @_; $a cmp $b };
    }

    my $sub = $cmp->[type($l)][type($r)];
    unless ($sub) {
        die sprintf(q(unknown cmp for (%s, %s)), $l, $r);
    }

    return $sub;
}

sub decompose {
    my $str = shift;

    state $S = S;
    state $F = F;
    state $I = I;
    state $Y = Y;

    my @parts;
    my $idx = 0;
    while ($idx < length($str)) {
        for (substr($str, $idx)) {
            when (/($S)/) { push @parts, $1; $idx += length($1) }
            when (/($F)/) { push @parts, $1; $idx += length($1) } # must test F before I
            when (/($I)/) { push @parts, $1; $idx += length($1) }
            when (/($Y)/) { push @parts, $1; $idx += length($1) }
            default { die sprintf(q(unknown decomposition: %s), substr($str, $idx)) }
        }
    }

    return @parts;
}

sub strverscmp {
    my ($l, $r) = @_;

    my @l = decompose($l);
    my @r = decompose($r);

    while (@l > 0 && @r > 0) {
        my $lt = shift @l;
        my $rt = shift @r;
        my $cmp = select_cmp($lt, $rt);
        my $rv = $cmp->($lt, $rt);
        if ($rv != 0) {
            return $rv;
        }
    }

    if (@l == 0 && @r == 0) {
        return 0;
    } elsif (@l == 0 && @r != 0) {
        return -1;
    } elsif (@l != 0 && @r == 0) {
        return  1;
    } else {
        die;
    }
}

sub strverssort {
    return sort { strverscmp($a, $b) } @_;
}

1;

__END__

=head1 NAME

Sort::strverscmp -- Compare strings while treating digits characters numerically.

=head1 SYNOPSIS

  my @list = qw(a A beta9 alpha9 alpha10 alpha010 1.0.5 1.05);
  my @them = strverssort(@list);
  print join(' ', @them), "\n";

Prints:

  1.05 1.0.5 A a alpha010 alpha9 alpha10 beta9

=head1 DESCRIPTION

Pure Perl implementation of GNU strverscmp.

=head1 AUTHOR

Nathaniel Nutter C<nnutter@cpan.org>

=head1 COPYRIGHT AND DISCLAIMER

Copyright 2013, The Genome Institute at Washington University C<nnutter@cpan.org>, all rights
reserved.  This program is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

This program is distributed in the hope that it will be useful, but
without any warranty; without even the implied warranty of
merchantability or fitness for a particular purpose.
