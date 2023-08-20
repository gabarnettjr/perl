#!/usr/bin/perl

use strict;
use warnings;

use lib ".";
use Phs;

use lib "../LinearAlgebra";
use Matrix;
#!/usr/bin/perl

use strict;
use warnings;

use lib ".";
use Phs;

use lib "../LinearAlgebra";
use Matrix;

my $rbfExponent = 3;
my $polyDegree = 0;
my $n = 6;
my $N = 7;

################################################################################

my $x = Matrix::linspace(-1, 1, $n);
my $y = Matrix::linspace(-1, 1, $n);
my ($xx, $yy) = Matrix::meshgrid($x, $y);
$xx = $xx->flatten();  $yy = $yy->flatten();
my $nodes = $xx->vstack($yy);
my $zz = Phs::testFunc2d($nodes);

my $X = Matrix::linspace(-1, 1, $N);
my $Y = Matrix::linspace(-1, 1, $N);
my ($XX, $YY) = Matrix::meshgrid($X, $Y);
$XX = $XX->flatten();  $YY = $YY->flatten();
my $NODES = $XX->vstack($YY);
my $ZZ = Phs::testFunc2d($NODES);

my ($phs, $estimate);
eval { $phs = Phs::new($rbfExponent, $polyDegree, $nodes, $zz); };  die if $@;
eval { $estimate = $phs->evaluate($NODES); };  die if $@;

# $phs->coeffs()->disp();

# print "\$estimate = \n";
# $estimate->disp();
# print "\n";
# print "\$ZZ = \n";
# $ZZ->disp();

my $diff = $estimate->plus($ZZ->times(-1));
$diff->disp();
my $dims = 2;
my $exponent = 3;
my $polyDegree = 0;
my $n = 6;
my $N = 7;

################################################################################

my $x = Matrix::linspace(-1, 1, $n);
my $y = Matrix::linspace(-1, 1, $n);
my ($xx, $yy) = Matrix::meshgrid($x, $y);
$xx = $xx->flatten();  $yy = $yy->flatten();
my $nodes = $xx->vstack($yy);
my $zz = Phs::testFunc2d($nodes);

my $X = Matrix::linspace(-1, 1, $N);
my $Y = Matrix::linspace(-1, 1, $N);
my ($XX, $YY) = Matrix::meshgrid($X, $Y);
$XX = $XX->flatten();  $YY = $YY->flatten();
my $NODES = $XX->vstack($YY);
my $ZZ = Phs::testFunc2d($NODES);

my ($phs, $estimate);
eval { $phs = Phs::new($dims, $exponent, $polyDegree, $nodes, $zz); };  die if $@;
eval { $estimate = $phs->evaluate($NODES); };  die if $@;

# $phs->coeffs()->disp();

# print "\$estimate = \n";
# $estimate->disp();
# print "\n";
# print "\$ZZ = \n";
# $ZZ->disp();

my $diff = $estimate->plus($ZZ->times(-1));
$diff->disp();
