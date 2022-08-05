#!/mu/bin/perl

use strict;

# Create and execute a simple python script to plot a parabola

open(PY, ">plotParabola.py");

print PY "import numpy as np"                               . "\n";
print PY "import matplotlib.pyplot as plt"                  . "\n";
print PY ""                                                 . "\n";
print PY "x = np.linspace(-1, 1, 26)"                       . "\n";
print PY "y = x**2"                                         . "\n";
print PY "plt.plot(x, y)"                                   . "\n";
print PY "plt.show()"                                       . "\n";
print PY ""                                                 . "\n";
print PY "print(\"x has \" + str(len(x)) + \" elements.\")" . "\n";
print PY "print(\"y has \" + str(len(y)) + \" elements.\")" . "\n";

close PY;

my @out = `python plotParabola.py`;

foreach my $x (@out) {
	print $x;
}
