#!/usr/bin/perl

package Poker;

use strict;
use warnings;

use lib ".";
use Card;

sub matches {
    # Define how many make a match.
    my $matchDefinition = shift;
    # The number of matches you are checking for.
    my $matchesSought = shift;
    # Pointer to the hand array which is an array of pointers to cards.
    my $hand = shift;
    # Find out how many there are of each card in the hand.
    my @numSame = ();
    foreach my $card (@{$hand}) {
        my $count = 0;
        foreach my $c (@{$hand}) {
            if (Card::sameFace $c, $card) {
                $count++;
            }
        }
        push @numSame, $count;
    }
    # Check if it is a 5-card full house.  Do not count these as regular matches.
    if ((scalar @numSame) == 5) {
        my $tmp = join ",", @numSame;
        $tmp =~ s/2//g;
        $tmp =~ s/3//g;
        $tmp =~ s/,//g;
        if (not $tmp) {
            return "full house";
        }
    }
    # Count the number of matches.
    my $howMany = 0;
    foreach my $num (@numSame) {
        if ($num == $matchDefinition) {
            $howMany++;
        }
    }
    my $numMatches = ($howMany / $matchDefinition);
    # Return true or false.
    if ($numMatches == $matchesSought) {
        return 1;
    }
    return 0;
}

sub flush {
    my $hand = shift;

    # Check if all cards in the hand have the same suit.
    my $firstCard = @{$hand}[0];
    for (my $i = 1; $i < (scalar @{$hand}); $i++) {
        if (not (Card::sameSuit $firstCard, @{$hand}[$i])) {
            return 0;
        }
    }
    return 1;
}

return 1;

