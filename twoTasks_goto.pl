#!/mu/bin/perl

use strict;

for (my $i = 0; $i < 3; $i++) {
    print("\nHi, Mom!");
}

VEGGIES:

print("\n\nPlease enter a vegetable name from this list:");
print("\n\npea\ncarrot\ncelery\ncucumber\npotato\n\n");

chomp(my $veg = <STDIN>);

$veg = lc($veg);

print("\nYou chose:  $veg");

if ($veg eq "pea" || $veg eq "carrot" || $veg eq "cucumber") {
    $veg .= "s";
} elsif ($veg eq "potato") {
    $veg .= "es";
} elsif ($veg ne "celery") {
    print("\n\nYou did not choose a vegetable from the list!  Try again.");
    goto VEGGIES;
}

print("\n\nDon't forget to eat your " . $veg . "!");

print("\n\n");

