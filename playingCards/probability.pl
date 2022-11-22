#!/usr/bin/perl

use strict;
use warnings;

use lib ".";
use Deck;
use Hand;
use Poker;

# Set parameters.
my $cardsPerHand = 5;
my $recordSuccess = 1;
my $N = 1000;

# Print parameters to standard output.
print "faces = " . (join " ", Card::faces) . "\n";
print "suits = " . (join " ", Card::suits) . "\n";
print "cards per hand = " . $cardsPerHand . "\n";
print "total shuffles in this experiment = $N\n";

# Deal a lot of hands and estimate the probability of something.
my $startTime = time;
if ($recordSuccess) {
    open OUT, ">out.txt" or die "\nFailed to open file for writing.\n";
}
my $numHands = 0;
my $numFound = 0;
for (my $i = 0; $i < $N; $i++) {
    my @deck = Deck::new;
    @deck = Deck::shuffle \@deck;
    while ((scalar @deck) >= $cardsPerHand) {
        my @h = Hand::new $cardsPerHand, \@deck;
        if ((Poker::matches 3, 1, \@h) eq "full house") {
            $numFound++;
            if ($recordSuccess) {
                print OUT (Hand::toString \@h);
            }
        }
        $numHands++;
    }
}
close OUT;
print "\nprobability = $numFound / $numHands = " . ($numFound / $numHands * 100 ) . "\%\n";
my $endTime = time;
print ("\ntime elapsed = " . ($endTime - $startTime) . " seconds\n");

# # Get a new deck and shuffle it.
# my @d = Deck::new;
# @d = Deck::shuffle \@d;

# # Deal two hands and display them.
# my @h1 = Hand::new $cardsPerHand, \@d;
# my @h2 = Hand::new $cardsPerHand, \@d;
# print (Hand::toString \@h1);
# print (Hand::toString \@h2);

# # Display what remains of the deck.
# print (Deck::toString \@d);





