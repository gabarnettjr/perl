
use strict;

print("\nWhat is your name?\nResponse: ");

chomp(my $name = <STDIN>);

print("\nWelcome, to perl, $name!\n");

my @currTime = localtime;

for (my $i = 0; $i < @currTime; $i++) {
    print("\n\$currTime[$i] = $currTime[$i]");
}

print("\n\n");

