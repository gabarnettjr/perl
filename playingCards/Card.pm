#!/usr/bin/perl

package Card;

use strict;
use warnings;

sub suits {
    return ("spades", "clubs", "diamonds", "hearts");
}

sub faces {
    return ("2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A");
}

sub new {
    my ($face, $suit) = @_;

    my $f = " " . join(" ", Card::faces) . " ";
    my $s = " " . join(" ", Card::suits) . " ";
    if ($f =~ / $face /) {
        if ($s =~ / $suit /) {
            return ($face, $suit);
        }
    }
    die("\nInvalid face or suit.\n");
}

sub sameFace {
    my ($c1, $c2) = @_;

    if (@{$c1}[0] eq @{$c2}[0]) {
        return 1;
    }
    return 0;
}

sub sameSuit {
    my ($c1, $c2) = @_;

    if (@{$c1}[1] eq @{$c2}[1]) {
        return 1;
    }
    return 0;
}

sub sameCard {
    my ($c1, $c2) = @_;

    if (Card::sameSuit($c1, $c2)) {
        if (Card::sameFace($c1, $c2)) {
            return 1;
        }
    }
    return 0;
}

sub toString {
    my $card = shift;

    my $s = sprintf("%-2s of %-8s\n", @{$card}[0], @{$card}[1]);
    return $s;
}

return 1;








