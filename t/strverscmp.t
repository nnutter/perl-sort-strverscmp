use strict;
use warnings;

use Test::More tests => 3;

use Sort::strverscmp;

subtest 'decompose' => sub {
    my @cases = (
        ['abc-123', 'abc', '-', '123'],
        ['abc .2', 'abc ', '.', '2'],
        ['abc 0.2', 'abc ', '0', '.', '2'],
        ['1.0', '1', '.', '0'],
        ['v_5', 'v', '_', '5'],
    );
    plan tests => scalar(@cases);

    for my $case (@cases) {
        my ($orig, @eparts) = @$case;
        my @parts = Sort::strverscmp::decompose($orig);
        is_deeply(\@parts, \@eparts, qq(parts matched for '$orig'));
    }
};

subtest 'GNU strverscmp examples' => sub {
    plan tests => 5;

    is(strverscmp('no digit', 'no digit'), 0, q('no digit' == 'no digit'));
    is(strverscmp('item#99', 'item#100'), -1, q('item#99' < 'item#100'));
    is(strverscmp('alpha1', 'alpha001'), 1, q('alpha1' > 'alpha001'));
    is(strverscmp('part1_f012', 'part1_f01'), 1, q('part1_f012' > 'part1_f01'));
    is(strverscmp('foo.009', 'foo.0'), -1, q('foo.009' < 'foo.0'));
};

subtest 'custom examples' => sub {
    plan tests => 10;

    is(strverscmp('alpha1', 'beta1'), -1, q('alpha1' < 'beta1'));
    is(strverscmp('g', 'G'), 1, q('g' > 'G'));
    is(strverscmp('1.0.5', '1.0.50'), -1, q('1.0.5' < '1.0.50'));
    is(strverscmp('1.0.5', '1.05'), 1, q('1.0.5' > '1.05'));
    is(strverscmp('hi .2', 'hi 0.2'), -1, q('hi .2' < 'hi 0.2'));
    is(strverscmp('hi .2', 'hi abc'), -1, q('hi .2' < 'hi abc'));
    is(strverscmp('hi 0', 'hi 009'), 1, q('hi 0' > 'hi 009'));
    is(strverscmp('hi.0', 'hi.009'), 1, q('hi.0' > 'hi.009'));
    is(strverscmp('hi-0', 'hi-009'), 1, q('hi-0' > 'hi-009'));
    is(strverscmp('hi-0', 'hi.0'), -1, q('hi-0' < 'hi.0'));
};
