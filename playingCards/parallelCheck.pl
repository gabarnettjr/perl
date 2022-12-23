#!/usr/bin/perl

use strict;
use warnings;

use lib ".";
use Hand;
use Deck;
use Poker;
use IO;

# Necessary inputs for this script.
my $nShuffles = shift;
my $block = shift;
my $dealsPerShuffle = shift;
my $cardsPerHand = shift;
my $saveDir = shift;

# Get the array of types of hands to check for.
my @checkingFor = ();
my $numChecks = Poker::specialHands(\@checkingFor);

# Make an array of string variables to hold data, and an
# array of integers to keep track of how many of each result.
my @toBeSaved = ();
my @numFound = ();
for (my $k = 0; $k < $numChecks; $k++) {
    push(@toBeSaved, "");
    push(@numFound, 0);
}

# Deal cards from lots of decks and keep track of stuff.
# my $numHands = 0;
for (my $k = 0; $k < $nShuffles; $k++) {
    my @deck = Deck::new();
    Deck::shuffle(\@deck);
    for (my $j = 0; $j < $dealsPerShuffle; $j++) {
        my @h = Hand::new($cardsPerHand, \@deck);
        Poker::checkHand(\@h, \@numFound, $numChecks, \@toBeSaved);
    }
    # $numHands = $numHands + $dealsPerShuffle;
}

# Print to small files in subdirectory.
my $subDir = sprintf("%03i", $block);
IO::printToFiles($numChecks, \@checkingFor, \@numFound, \@toBeSaved, $saveDir, $subDir);

# Indicate execution is done by saving a file.
open(OUT, ">$saveDir/done$subDir.txt") || die("\nFailed opening file for writing.\n");
close(OUT);






