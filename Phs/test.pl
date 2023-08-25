#!/usr/bin/perl

use strict;
use warnings;

use lib ".";
use Phs;

use lib "../LinearAlgebra";
use Matrix;

my $rbfExponent = 3;
my $polyDegree = 1;
my $n = 6;
my $N = 7;

################################################################################

my ($x, $y, $xx, $yy, $nodes, $zz);
eval {
    $x = Matrix::linspace(-1, 1, $n);
    $y = Matrix::linspace(-1, 1, $n);
    ($xx, $yy) = Matrix::meshgrid($x, $y);
    $xx = $xx->flatten();  $yy = $yy->flatten();
    $nodes = $xx->vstack($yy);
    $zz = Phs::testFunc2d($nodes);
};
die if $@;

my ($X, $Y, $XX, $YY, $NODES, $ZZ);
eval {
    $X = Matrix::linspace(-1, 1, $N);
    $Y = Matrix::linspace(-1, 1, $N);
    ($XX, $YY) = Matrix::meshgrid($X, $Y);
    $XX = $XX->flatten();  $YY = $YY->flatten();
    $NODES = $XX->vstack($YY);
    $ZZ = Phs::testFunc2d($NODES);
};
die if $@;

my ($phs, $estimate);
eval {
    $phs = Phs::new($rbfExponent, $polyDegree, $nodes, $zz);
    $estimate = $phs->evaluate($NODES);
};
die if $@;

# $phs->coeffs()->disp();

my $diff;
eval {
    print "\$estimate = \n";
    $estimate->disp();
    print "\n";
    print "\$ZZ = \n";
    $ZZ->disp();
    print "\n";
    $diff = $estimate->plus($ZZ->times(-1));
    print "\$diff = \n";
    $diff->disp();
};
die if $@;
