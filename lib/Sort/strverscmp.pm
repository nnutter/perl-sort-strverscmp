package Sort::strverscmp;

require Sort::strverscmp::StringIterator;

use Exporter 'import';
use v5.10;

use strict;
use warnings;

our $VERSION = "0.011";
our @EXPORT = qw(strverscmp);
our @EXPORT_OK = qw(strverssort);

# strnum_cmp from bam_sort.c
sub strverscmp {
    my ($a, $b) = @_;

    my $ai = Sort::strverscmp::StringIterator->new($a);
    my $bi = Sort::strverscmp::StringIterator->new($b);

    do {
        if (_isdigit($ai->head) && _isdigit($bi->head)) {
            my $an = (($ai->head . $ai->tail) =~ /^(\d*)/)[0];
            my $bn = (($bi->head . $bi->tail) =~ /^(\d*)/)[0];
            if ($an =~ /^0\d/ || $bn =~ /^0\d/) {
                return _fcmp($an, $bn);
            } else {
                if ($an <=> $bn) {
                    return ($an <=> $bn);
                }
            }
        } else {
            if ($ai->head cmp $bi->head) {
                return ($ai->head cmp $bi->head);
            }
        }
        $ai->advance();
        $bi->advance();
    } while (defined($ai->head) && defined($bi->head));

    return $ai->head ? 1 : $bi->head ? -1 : 0;
}

sub strverssort {
    return sort { strverscmp($a, $b) } @_;
}

sub _isdigit {
    my $c = shift;
    return (defined($c) && $c =~ /^\d+$/);
}

sub _fcmp {
    my ($l, $r) = @_;

    my ($lz, $ln, $rz, $rn);
    ($lz, $ln) = _decompose_fractional($l);
    ($rz, $rn) = _decompose_fractional($r);

    if (length($lz) == length($rz)) {
        return $ln <=> $rn;
    } else {
        return (length($lz) > length($rz) ? -1 : 1);
    }
}

sub _decompose_fractional {
    my ($zeroes, $number) = shift =~ /^(0*)(\d+)$/;
    return ($zeroes, $number);
}

1;
__END__

=encoding utf-8

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

Copyright 2013, The Genome Institute at Washington University
C<nnutter@cpan.org>, all rights reserved.  This program is free software; you
can redistribute it and/or modify it under the same terms as Perl itself.

This program is distributed in the hope that it will be useful, but without any
warranty; without even the implied warranty of merchantability or fitness for a
particular purpose.

=cut

