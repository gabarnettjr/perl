#!/mu/bin/perl

use strict;

open(FH, ">", "answer.txt") || die $!;

print "\nDo you like negative numbers or positive?\n";
chomp(my $answer = <STDIN>);
print FH $answer;

print "\nWhy did you give this answer?\n";
chomp(my $answer = <STDIN>);
print FH "\n" . $answer;

close(FH);

