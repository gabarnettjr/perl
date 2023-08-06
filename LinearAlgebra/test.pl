#!/usr/bin/perl

use strict;
use warnings;

use lib ".";
use Matrix;

print "\n";

my $A = Matrix::new([[1,2,3], [4,5,6], [7,8,9]]);
my $B = Matrix::new([[9,8,7], [6,5,4], [3,2,1]]);
my $C = $A->add($B);
print "\$A + \$B = \n";
$C->disp();

print "\n";

my $x = Matrix::new([[1,2,3]]);
my $y = Matrix::new([[3,2,1]]);
my $z = $x->add($y);
print "\$x + \$y = \n";
$z->disp();

print "\n";

my $u = Matrix::new([[1], [2], [3]]);
my $v = Matrix::new([[3], [2], [1]]);
my $w = $u->add($v);
print "\$u + \$v = \n";
$w->disp();
