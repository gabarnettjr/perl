#!/usr/bin/perl

use strict;
use warnings;

use lib ".";
use Phs;

use lib "../LinearAlgebra";
use Matrix;

my $n = 6;
my $N = 19;

my $x = Matrix::linspace(-1, 1, $n);
my $y = Matrix::linspace(-1, 1, $n);
my ($xx, $yy) = Matrix::meshgrid($x, $y);

my $X = Matrix::linspace(-1, 1, $N);
my $Y = Matrix::linspace(-1, 1, $N);
my ($XX, $YY) = Matrix::meshgrid($X, $Y);

my $phs = Phs::new(2, 5, $nodes);
