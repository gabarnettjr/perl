#!/mu/bin/perl

use strict;

print("\nEnter a list of strings.\n");
print("Press CTRL-D when you are done (Linux).\n");
print("Press CTRL-Z then <ENTER> when you are done (Windows).\n\n");

my @array = <STDIN>;

print ("\n", reverse(@array), "\n");

