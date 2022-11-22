#!/usr/bin/perl

package Hand;

use strict;
use warnings;

use lib ".";
use Card;

sub new {
    my ($cardsPerHand, $deck) = @_;

    my @hand = ();
    for (my $i = 1; $i <= $cardsPerHand; $i++) {
        push @hand, (shift @{$deck});
    }
    return @hand;
}

sub toString {
    my $hand = shift;

    my $s = "\n";
    foreach my $card (@{$hand}) {
        $s .=  (Card::toString $card);
    }
    return $s;
}

return 1;

