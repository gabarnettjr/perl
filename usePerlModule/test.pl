#!/mu/bin/perl

use strict;

use lib "/home/gregorybarne/perl/modules";
use MyModule;

my @v = (1, 2, 3, "hello");

@v = MyModule::flip(@v);

print("\n");

while (@v > 0) {
    print(shift(@v) . " ");
}

# foreach my $x (@v) {
#     print($x . " ");
# }

print("\n\n");

print("\$C = $MyModule::C\n\n");

