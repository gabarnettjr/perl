#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin";
use Matrix;

print "\n";

my $A = Matrix::new(4, 3);
for (my $i = 0; $i < $A->numRows(); $i++) {
    for (my $j = 0; $j < $A->numCols(); $j++) {
        $A->set($i, $j, $i + $j);
    }
}
my $AA = $A->copy();
print "\$AA = \n";
$AA->disp();

print "\n";

my $B = Matrix::new([[9,8,7,6,5], [4,3,2,1,0], [-1,-2,-3,-4,-5]]);
print "\$B = \n";
$B->disp();

print "\n";

my $C = $A->times($B);
print "\$A->times(\$B) = \n";
$C->disp();

print "\n";

my $x = Matrix::new([[1,2,3], [4,5,6]]);
print "\$x = \n";
$x->disp();

print "\n";

my $y = Matrix::new([[6,5,4], [3,2,1]]);
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

################################################################################

print "\n";

$A = Matrix::new([[1,1,2], [2,3,-1], [3,5,9]]);
print "\$A = \n";
$A->disp();

print "\n";

my $b = Matrix::new([[0], [1], [-2]]);
print "\$b = \n";
$b->disp();

print "\n";

$x = $A->solve($b);
print "\$A->solve(\$b) = \n";
$x->disp();

print "\n";

my $prod = $A->times($x);
print "\$A->times(\$x) = \n";
$prod->disp();
