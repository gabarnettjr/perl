#!usr/bin/perl

package Deck;

use strict;
use warnings;

use lib ".";
use Card;

sub new {
    my @d = ();
    foreach my $suit (Card::suits) {
        foreach my $face (Card::faces) {
            my @c = Card::new($face, $suit);
            push(@d, \@c);
        }
    }
    return @d;
}

sub shuffleAlternate {
    my $d = shift;

    my @ret = ();
    while (scalar(@{$d}) > 0) {
        my $ind = int(rand(scalar(@{$d})));
        push(@ret, @{$d}[$ind]);
        splice(@{$d}, $ind, 1);
    }
    return @ret;
}

sub swap {
    my ($deck, $ind1, $ind2) = @_;

    my $tmp = @{$deck}[$ind1];
    @{$deck}[$ind1] = @{$deck}[$ind2];
    @{$deck}[$ind2] = $tmp;
}

sub shuffle {
    my $deck = shift;

    my $nCards = scalar(@{$deck});
    for (my $i = 0; $i < $nCards; $i++) {
        my $j = int(rand($nCards));
        Deck::swap($deck, $i, $j);
    }
}

sub toString {
    my $d = shift;

    my $s = "\n";
    foreach my $card (@{$d}) {
        $s .=  Card::toString($card);
    }
    return $s;
}

return 1;

