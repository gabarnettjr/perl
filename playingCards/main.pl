#!/usr/bin/perl

use strict;
use warnings;

use lib ".";
use Deck;
use Hand;
use Poker;
use IO;

my $startTime = time;

# Set parameters.
my $parallel = 16;
my $totalShuffles = $parallel * 1e3;

my $cardsPerHand = 5;
my $dealsPerShuffle = int(52 / $cardsPerHand);

my $d = IO::separator();
my $saveDir = "..$d..$d..$d" . "pokerOutput";

################################################################################

# Just get the total number of hands right away instead of counting them.
my $numHands = $totalShuffles * $dealsPerShuffle;

# List of what will be checked for.
my @checkingFor = ();
my $numChecks = Poker::specialHands(\@checkingFor);

# Tell the user what is going on.
IO::greeting(\@checkingFor, $cardsPerHand, $totalShuffles, $dealsPerShuffle);

# Remove any subdirectories that might still exist.
IO::removeSubdirectories($saveDir);

# Run experiments in parallel.
my $nShuffles = int($totalShuffles / $parallel);
for (my $block = 0; $block < $parallel; $block++) {
    if ($^O eq "linux") {
        system("./parallelCheck.pl $nShuffles $block $dealsPerShuffle $cardsPerHand $saveDir &");
    } else {
        my $cmd = "start /b ";
        $cmd .= "C:\\Strawberry\\perl\\bin\\perl ";
        $cmd .= "C:\\Users\\gabar\\OneDrive\\perl\\playingCards\\parallelCheck.pl ";
        $cmd .= "$nShuffles $block $dealsPerShuffle $cardsPerHand $saveDir";
        system($cmd);
    }
}

# Wait until the parallel execution completes.
my $done = 0;
while (! $done) {
    my $count = 0;
    for (my $i = 0; $i < $parallel; $i++) {
        my $tmp = sprintf("%03s", $i);
        if (-e "$saveDir/done$tmp.txt") {
            $count++;
        }
    }
    if ($count == $parallel) {
        $done = 1;
        if ($^O eq "linux") {
            system("rm $saveDir/done*.txt");
        } else {
            system("del /Q $saveDir\\done*.txt");
        }
    }
    sleep(1);
}

# Gather results.
my @numFound = IO::gather(\@checkingFor, $numChecks, $saveDir, $parallel);

# Print a summary of results of the experiment to standard output.
printf("\nHANDS DEALT = %1.3e", ($totalShuffles * $dealsPerShuffle));
print("\n");
my $i = 0;
my $sum = 0;
foreach my $num (@numFound) {
    $sum = $sum + $num;
    my $odds;
    if ($num == 0) {
        $odds = "";
    } else {
        $odds = int($numHands / $num);
    }
    printf("\n%2s %-17s %-10s %10.5f%% %10s", $i, $checkingFor[$i]
    , $num, ($num / $numHands * 100), $odds);
    $i++;
}
printf("\n");
printf("\n%2s %-17s %-10s %10.5f%% %10s", "", "", $sum, ($sum / $numHands * 100), "");
print("\n");

my $endTime = time;
print("\ntime elapsed = " . ($endTime - $startTime) . " seconds\n");






