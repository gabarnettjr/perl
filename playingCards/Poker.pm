#!/usr/bin/perl

package Poker;

use strict;
use warnings;

use lib ".";
use Card;

################################################################################

sub specialHands {
    # The input is a pointer to an empty array.
    # This subroutine fills the array and returns its length.

    my $checkingFor = shift;

    push(@{$checkingFor}, "nothing_special");
    push(@{$checkingFor}, "pair");
    push(@{$checkingFor}, "two_pairs");
    push(@{$checkingFor}, "three_of_a_kind");
    push(@{$checkingFor}, "straight");
    push(@{$checkingFor}, "flush");
    push(@{$checkingFor}, "full_house");
    push(@{$checkingFor}, "four_of_a_kind");
    push(@{$checkingFor}, "straight_flush");
    push(@{$checkingFor}, "royal_flush");
    return scalar(@{$checkingFor});
}

################################################################################

sub straights {
    # Collect all possible 5-card straights as an array of pointers to arrays.

    my @faces = Card::faces();
    unshift(@faces, "A");
    my @ret = ();
    for (my $i = 0; $i < 10; $i++) {
        my @tmp = @faces;
        @tmp = splice(@tmp, $i, 5);
        push(@ret, \@tmp);
    }
    return @ret;
}

################################################################################

sub matches {
    # Based on the definition of a match (how many make a match), and on how
    # many matches you are looking for, this subroutine returns 1 if the input
    # hand has the required number of matches, and 0 otherwise.

    # Define how many make a match.
    my $matchDefinition = shift;
    # The number of matches you are checking for.
    my $matchesSought = shift;
    # Pointer to the hand array, which is an array of pointers to cards.
    my $h = shift;

    # Find out how many there are of each card in the hand.
    my @numSame = ();
    foreach my $card (@{$h}) {
        my $count = 0;
        foreach my $c (@{$h}) {
            if (Card::sameFace($c, $card)) {
                $count++;
            }
        }
        push(@numSame, $count);
    }

    # Count the number of matches.
    my $numMatches = 0;
    foreach my $num (@numSame) {
        if ($num == $matchDefinition) {
            $numMatches++;
        }
    }
    $numMatches = ($numMatches / $matchDefinition);

    # Return true or false.
    if ($numMatches == $matchesSought) {
        return 1;
    }
    return 0;
}

################################################################################

sub fullHouse {
    # Check if a hand is a full house.

    # Pointer to the hand array which is an array of pointers to cards.
    my $h = shift;

    # Find out how many there are of each card in the hand.
    my @numSame = ();
    foreach my $card (@{$h}) {
        my $count = 0;
        foreach my $c (@{$h}) {
            if (Card::sameFace($c, $card)) {
                $count++;
            }
        }
        push(@numSame, $count);
    }

    # Check if it is a 5-card full house.
    if (scalar(@numSame) == 5) {
        my $tmp = join(",", @numSame);
        $tmp =~ s/2//g;
        $tmp =~ s/3//g;
        $tmp =~ s/,//g;
        if (! $tmp) {
            return 1;
        }
    } else {
        die("\nFull house is only defined for 5-card hands.\n");
    }
    return 0;
}

################################################################################

sub flush {
    # Check if all cards in a hand have the same suit.

    # Pointer to the hand you are checking.
    my $h = shift;

    my $firstCard = @{$h}[0];
    for (my $i = 1; $i < scalar(@{$h}); $i++) {
        if (! Card::sameSuit($firstCard, @{$h}[$i])) {
            return 0;
        }
    }
    return 1;
}

################################################################################

sub straight {
    # Check if the hand contains 5 cards "in a row".

    # Pointer to the hand you are checking.
    my $h = shift;

    foreach my $f (Poker::straights()) {
        my $count = 0;
        foreach  my $face (@{$f}) {
            if (Hand::containsFace($h, $face)) {
                $count++;
            }
        }
        if ($count == 5) {
            return 1;
        }
    }
    return 0;
}

################################################################################

sub checkHand {
    # This subroutine checks a poker hand to see if it is anything special.

    # Pointer to the hand you are checking.
    my $h = shift;
    # Pointer to the array keeping track of how many of each type of hand.
    my $numFound = shift;
    # Number of different things you are checking for.
    my $numChecks = shift;
    # Array of strings to be printed to various output files.
    my $toBeSaved = shift;

    my $bool1 = Poker::matches(2, 1, $h);
    my $bool2 = Poker::matches(2, 2, $h);
    my $bool3 = Poker::matches(3, 1, $h);
    my $bool4 = Poker::straight($h);
    my $bool5 = Poker::flush($h);
    my $bool6 = Poker::fullHouse($h);
    my $bool7 = Poker::matches(4, 1, $h);

    for (my $test = 0; $test < $numChecks; $test++) {

        my $bool = 0;

        if ($test == 0) {
            if (! $bool1 && ! $bool2 && ! $bool3 && ! $bool4
            && ! $bool5 && ! $bool7) {
                $bool = 1;
            }
        } elsif ($test == 1) {
            $bool = ($bool1 && ! $bool6);
        } elsif ($test == 2) {
            $bool = $bool2;
        } elsif ($test == 3) {
            $bool = ($bool3 && ! $bool6);
        } elsif ($test == 4) {
            $bool = ($bool4 && ! $bool5);
        } elsif ($test == 5) {
            $bool = ($bool5 && ! $bool4);
        } elsif ($test == 6) {
            $bool = $bool6;
        } elsif ($test == 7) {
            $bool = $bool7;
        } elsif ($test == 8) {
            if ($bool4 && $bool5) {
                my $tmp1 = Hand::containsFace($h, "10");
                my $tmp2 = Hand::containsFace($h, "A");
                if (! ($tmp1 && $tmp2)) {
                    $bool = 1;
                }
            }
        } elsif ($test == 9) {
            if ($bool4 && $bool5) {
                my $tmp1 = Hand::containsFace($h, "10");
                my $tmp2 = Hand::containsFace($h, "A");
                if ($tmp1 && $tmp2) {
                    $bool = 1;
                }
            }
        }

        # If the hand passes the test, record it in @{$numFound}.
        if ($bool) {
            @{$numFound}[$test]++;
            # @{$toBeSaved}[$test] .=  "\n\#@{$numFound}[$test]";
            # @{$toBeSaved}[$test] .=  "\n";
            @{$toBeSaved}[$test] .= Hand::toString($h);
        }
    }
}

################################################################################

return 1;









