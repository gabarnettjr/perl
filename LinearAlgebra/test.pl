#!/usr/bin/perl

use strict;
use warnings;

use lib ".";
use Matrix;

print "\n";

# my $A = Matrix::new([[1,2,3], [4,5,6], [7,8,9]]);
my $A = Matrix::new(4, 3);
for (my $i = 0; $i < $A->numRows(); $i++) {
    for (my $j = 0; $j < $A->numCols(); $j++) {
        $A->set($i, $j, $i + $j);
    }
}
print "\$A = \n";
$A->disp();

print "\n";

my $B = Matrix::new([[9,8,7,6,5], [4,3,2,1,0], [-1,-2,-3,-4,-5]]);
print "\$B = \n";
$B->disp();

print "\n";

my $C = $A->times($B);
print "\$A->times(\$B) = \n";
$C->disp();

print "\n";

my $x = Matrix::new([[1,2,3]]);
print "\$x = \n";
$x->disp();

print "\n";

my $y = Matrix::new([[3,2,1]]);
print "\$y = \n";
$y->disp();

print "\n";

my $z = $x->dotTimes($y);
print "\$x->dotTimes(\$y) = \n";
$z->disp();

print "\n";

my $u = Matrix::new([[1], [2], [3]]);
print "\$u = \n";
$u->disp();

print "\n";

my $v = Matrix::new([[3], [2], [1]]);
print "\$v = \n";
$v->disp();

print "\n";

my $w = $u->plus($v);
print "\$u->plus(\$v) = \n";
$w->disp();
