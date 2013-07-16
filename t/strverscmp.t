use strict;
use warnings;

use Test::More tests => 15;
use Sort::strverscmp;

# strverscmp.c examples
is(strverscmp('no digit', 'no digit'), 0, q('no digit' == 'no digit'));
is(strverscmp('item#99', 'item#100'), -1, q('item#99' < 'item#100'));
is(strverscmp('alpha1', 'alpha001'), 1, q('alpha1' > 'alpha001'));
is(strverscmp('part1_f012', 'part1_f01'), 1, q('part1_f012' > 'part1_f01'));
is(strverscmp('foo.009', 'foo.0'), -1, q('foo.009' < 'foo.0'));

# Custom Examples
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
