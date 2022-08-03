#!/mu/bin/perl

use strict;

# Print something three times to standard output.
for (my $i = 0; $i < 3; $i++) {
    print("\nHi, Mom!");
}

# Call the veggies() subroutine to get the vegetable from the user.
my $veg = veggies();

print("\n\nDon't forget to eat your " . $veg . "!");

print("\n\n");

###########################################################

# Subroutine to get the vegetable name from the user.

sub veggies {
    
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
        $veg = veggies();
    }

    return $veg;
}

###########################################################

