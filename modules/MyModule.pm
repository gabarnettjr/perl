#!/mu/bin/perl

package MyModule;

use strict;

sub flip {
    my @x = ();
    while (@_ > 0) {
        push(@x, pop(@_));
    }
    return @x;
}

our $C = 3.14;

