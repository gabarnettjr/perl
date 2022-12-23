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
        push(@hand, (shift @{$deck}));
    }
    return @hand;
}

sub contains {
    # Determine if a hand contains a specific card.
    my ($hand, $card) = @_;

    foreach my $c (@{$hand}) {
        if (Card::sameCard($c, $card)) {
            return 1;
        }
    }
    return 0;
}

sub containsFace {
    # Determine if a hand contains a card with a specific face.
    my ($hand, $face) = @_;

    foreach my $c (@{$hand}) {
        if (@{$c}[0] eq $face) {
            return 1;
        }
    }
    return 0;
}

sub toString {
    my $hand = shift;

    my $s = "\n";
    foreach my $card (@{$hand}) {
        $s .=  Card::toString($card);
    }
    return $s;
}

return 1;








