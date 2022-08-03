#!/mu/bin/perl

use strict;

use Capture::Tiny "capture";

# # Method 1:
# open(FH, "<", "answer.txt") || die $!;
# my @answer = <FH>;
# close(FH);

# # Method 2:
# my @answer = qx(cat answer.txt);

# Method 3:
my (@answer, $stderr, $stdout) = capture {
    system("cat answer.txt");
};

###############################################################

print "\nYou gave these answers: \n"
. shift(@answer) . shift(@answer) . "\n\n";

print "\n\$stderr = $stderr\n";
print "\n\$stdout = $stdout\n";


