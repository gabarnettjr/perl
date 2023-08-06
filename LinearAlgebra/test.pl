#!/usr/bin/perl

use strict;
use warnings;

use lib "C:\\Users\\gabar\\gitRepos\\perl\\LinearAlgebra";
use Matrix;

my $A = Matrix::new([[1,2,3], [4,5,6], [7,8,9]]);

print "numRows = " . $A->numRows() . "\n";
print "numCols = " . $A->numCols() . "\n";
