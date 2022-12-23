#!/usr/bin/perl

package IO;

use strict;
use warnings;

################################################################################

sub separator {
    my $d;

    if ($^O eq "linux") {
        $d = "/";
    } elsif (lc($^O) =~ /win/) {
        $d = "\\";
    } else {
        die("\nPlease use linux or windows.\n");
    }

    return $d;
}

################################################################################

sub greeting {
    my @checkingFor = @{(shift)}; # types of hands you are looking for.
    my $cardsPerHand = shift;     # number of cards per hand.
    my $N = shift;                # total number of shuffles in the experiment.
    my $dealsPerShuffle = shift;  # number of deals after each shuffle.

    my $s = "";
    $s .= "\nHello, user.  You are playing 5-card draw.  You are dealt some cards.";
    $s .= "\nWhat is the probability that you are holding a full house?";
    $s .= "\nWhat about a straight flush?  You decide that you are more interested";
    $s .= "\nin calculating probabilities than in continuing your game of poker.";
    $s .= "\n";
    $s .= "\nWe will estimate the approximate probability experimentally, by forcing";
    $s .= "\nyour poor computer to deal cards over and over again, always keeping";
    $s .= "\ntrack of whether or not you achieved the desired outcome.";
    $s .= "\n";
    for (my $i = 0; $i < scalar(@checkingFor); $i++) {
        $s .= "\n[$i] $checkingFor[$i]";
    }
    $s .= "\n";
    $s .= "\nWe are going to estimate the probability of each of the above.";
    my $tmp = sprintf("%1.1e", $N);
    $s .= "\nThe computer will shuffle the deck $tmp times.  After each shuffle,";
    $s .= "\nyou will be dealt $dealsPerShuffle hands, and the computer will keep track of";
    $s .= "\nhow many times you get various things, like pairs, straights, etc.";
    $s .= "\n";
	
    print($s);
}

################################################################################

sub removeSubdirectories {
    my $saveDir = shift;

    for (my $i = 0; $i < 1000; $i++) {
        my $subDir = sprintf("%03i", $i);
        if (-e "$saveDir/$subDir") {
            if ($^O eq "linux") {
                system("rm -R $saveDir/$subDir");
            } else {
                system("del /Q /S $saveDir\\$subDir");
                system("rmdir $saveDir\\$subDir");
            }
        }
    }
}

################################################################################

sub printToFiles {
    # Print results to files in /mnt/c/Users/gabar/pokerOutput

    my $numChecks = shift;     # number of types of hands you are checking for.
    my $checkingFor = shift;   # array of names of hands you are checking for.
    my $numFound = shift;      # array holding num found of each type of hand.
    my $toBeSaved = shift;     # array of strings to be saved to record results.
    my $saveDir = shift;       # main location where results will be saved.
    my $subDir = shift;        # subDir of $saveDir where results will be saved.

    my $d = IO::separator();
    system("mkdir $saveDir$d$subDir");
    unless (open(OUT, ">$saveDir/$subDir/main.txt")) {
        die("\nFailed to open file for writing.\n");
    }
    print(OUT join(" ", @{$numFound}));
    print(OUT "\n");
    close(OUT);

    for (my $i = 0; $i < $numChecks; $i++) {
        unless (open(OUT, ">$saveDir/$subDir/@{$checkingFor}[$i].txt")) {
            die("\nFailed to open file for writing.\n");
        }
        print(OUT @{$toBeSaved}[$i]);
        close(OUT);
    }
}

################################################################################

sub gather {
    my $checkingFor = shift;
    my $numChecks = shift;
    my $saveDir = shift;
    my $parallel = shift;

    # Merge text files into one, for each type of hand.
    foreach my $type (@{$checkingFor}) {
        unless (open(OUT, ">$saveDir/$type.txt")) {
			die("\nFailed opening file for writing.\n");
		}
        my $count = 1;
        for (my $i = 0; $i < $parallel; $i++) {
            my $subDir = sprintf("%03s", $i);
			unless (open(IN, "<$saveDir/$subDir/$type.txt")) {
				die("\nFailed opening file for reading.\n");
			}
            my @in = <IN>;
            close(IN);
            foreach my $line (@in) {
                print(OUT $line);
                if ($line !~ /of/) {
                    print(OUT "\#$count\n");
                    $count++;
                }
            }
        }
        close(OUT);
    }

    # Combine counting array results into one total counting array.
    my @numFound = ();
    for (my $i = 0; $i < $numChecks; $i++) {
        push(@numFound, 0);
    }
    unless (open(OUT, ">$saveDir/main.txt")) {
		die("\nFailed opening main file for writing.\n");
	}
    for (my $i = 0; $i < $parallel; $i++) {
        my $subDir = sprintf("%03s", $i);
        unless (open(IN, "<$saveDir/$subDir/main.txt")) {
			die("\nFailed opening main file for reading.\n");
		}
        my @in = <IN>;
        close(IN);
        if (scalar(@in) != 1) {
            die("\nThis array should have only one element.\n");
        }
        my @tmp = split(/\s+/, $in[0]);
        for (my $i = 0; $i < $numChecks; $i++) {
            $numFound[$i] += $tmp[$i];
        }
        # Delete subdirectories, which are no longer needed.
        if ($^O eq "linux") {
            system("rm -R $saveDir/$subDir");
        } else {
            system("del /Q /S $saveDir\\$subDir");
            system("rmdir $saveDir\\$subDir");
        }
    }
    print(OUT join(" ", @numFound));
    close(OUT);

    return @numFound;
}

################################################################################

return 1;










