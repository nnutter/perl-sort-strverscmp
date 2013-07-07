# NAME

Sort::strverscmp -- Compare strings while treating digits characters numerically.

# SYNOPSIS

    my @list = qw(a A beta9 alpha9 alpha10 alpha010 1.0.5 1.05);
    my @them = strverssort(@list);
    print join(' ', @them), "\n";

Prints:

    1.05 1.0.5 A a alpha010 alpha9 alpha10 beta9

# DESCRIPTION

Pure Perl implementation of GNU strverscmp.

# AUTHOR

Nathaniel Nutter `nnutter@cpan.org`

# COPYRIGHT AND DISCLAIMER

Copyright 2013, The Genome Institute at Washington University `nnutter@cpan.org`, all rights
reserved.  This program is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

This program is distributed in the hope that it will be useful, but
without any warranty; without even the implied warranty of
merchantability or fitness for a particular purpose.
