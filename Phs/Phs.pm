#!/usr/bin/perl

package Phs;

# Polyharmonic Spline (PHS) interpolation class, for creating Phs objects.
# Greg Barnett
# August 2023

use strict;
use warnings;

################################################################################

# CONSTRUCTOR

sub new {
    # New object of type Phs
    die if scalar @_ != 4;
    my $dims = undef;
    my $rbfExponent = shift;
    my $polyDegree = shift;
    my $nodes = shift;
    my $values = shift;
    my $coeffs = undef;
    
    my $self = [$dims, $rbfExponent, $polyDegree, $nodes, $values, $coeffs];
    bless $self;
    eval { $self->coeffs(); };  die if $@;
    return $self;
}

################################################################################

# GETTERS

sub dims {
    # Number of dimensions of the PHS (1, 2, 3, ...)
    die if scalar @_ != 1;
    my $self = shift;
    
    my $dims = @{$self}[0];
    return $dims if defined $dims;
    return $self->nodes()->numRows();
    print STDERR "\nFailed to get dimensions.\n";  die;
}



sub rbfExponent {
    # Exponent in the PHS basis function (1, 3, 5, ...)
    die if scalar @_ != 1;
    my $self = shift;
    
    my $rbfExponent = @{$self}[1];
    return $rbfExponent if defined $rbfExponent;
    print STDERR "\nFailed to get RBF exponent.\n";  die;
}



sub polyDegree {
    # Highest polynomial degree included in the interpolation basis.
    die if scalar @_ != 1;
    my $self = shift;
    
    my $polyDegree = @{$self}[2];
    return $polyDegree if defined $polyDegree;
    print STDERR "\nFailed to get the max polynomial degree.\n";  die;
}



sub nodes {
    # Inputs where the PHS function has a known output (value)
    die if scalar @_ != 1 && scalar @_ != 2;
    my $self = shift;
    
    my $nodes = @{$self}[3];
    return $nodes if defined $nodes && ! scalar @_;
    return @{$nodes}[shift] if defined $nodes;
    print STDERR "\nFailed to get the nodes.\n";  die;
}



sub values {
    # Known function values that the PHS must match at the nodes
    die if scalar @_ != 1 && scalar @_ != 2;
    my $self = shift;
    
    my $values = @{$self}[4];
    return $values if defined $values && ! scalar @_;
    return @{$values}[shift] if defined $values;
    print STDERR "\nFailed to get the function values at the nodes.\n";  die;
}



sub coeffs {
    # Use the nodes and function values to determine the PHS coefficients.
    die if scalar @_ != 1 && scalar @_ != 2;
    my $self = shift;
    
    my $coeffs = @{$self}[5];
    return $coeffs if defined $coeffs && ! scalar @_;
    return @{$coeffs}[shift] if defined $coeffs;
    
    # Make the combined RBF plus polynomial A-matrix.
    my ($A, $p, $null);
    $A = $self->phi($self->r($self->nodes()));
    $p = $self->poly($self->nodes());
    $A = $A->hstack($p->transpose());
    $null = Matrix::zeros($p->numRows(), $p->numRows());
    $A = $A->vstack($p->hstack($null));
    
    # Solve a linear system to get the coefficients.
    $null = Matrix::zeros($p->numRows(), 1);
    return $A->solve($self->values()->transpose()->vstack($null));
}

################################################################################

sub poly {
    # The polynomial portion of the combined A-matrix.
    die if scalar @_ != 2;
    my $self = shift;
    die "\nNon-zero poly degree not yet implemented.\n" if $self->polyDegree() != 0;
    my $evalPts = shift;
    
    my $poly = Matrix::ones(1, $evalPts->numCols());
    
    # my $tmp = Matrix::zeros(1, $evalPts->numCols());
    
    # if ($self->polyDegree() >= 1) {
        
    # }
    
    return $poly;
}



sub evaluate {
    # Evaluate the PHS at the $evalPts.
    die if scalar @_ != 2;
    my $self = shift;
    my $evalPts = shift;
    
    my $out = $self->phi($self->r($evalPts))->hstack($self->poly($evalPts)->transpose())->times($self->coeffs());
    
    return $out->transpose();
}



sub r {
    # Radius matrix that can be used to create an A-matrix using an RBF.
    die if scalar @_ != 2;
    my $self = shift;
    my $evalPts = shift;
    
    my $r = Matrix::zeros($evalPts->numCols(), $self->nodes()->numCols());
    
    for (my $i = 0; $i < $evalPts->numCols(); $i++) {
        for (my $j = 0; $j < $self->nodes()->numCols(); $j++) {
            my $tmp = 0;
            for (my $k = 0; $k < $self->dims(); $k++) {
                $tmp += ($evalPts->item($k, $i) - $self->nodes()->item($k, $j)) ** 2;
            }
            $r->set($i, $j, sqrt $tmp);
        }
    }
    
    return $r;
}



sub phi {
    # The RBF portion of the combined A-matrix.
    my $self = shift;
    my $r = shift;
    
    my $phi = $r->copy();
    
    for (my $i = 0; $i < $phi->numRows(); $i++) {
        for (my $j = 0; $j < $phi->numCols(); $j++) {
            $phi->set($i, $j, $r->item($i, $j) ** $self->rbfExponent());
        }
    }
    
    return $phi;
}



sub testFunc2d {
    my $evalPts = shift;
    
    my $out = Matrix::zeros(1, $evalPts->numCols());
    
    for (my $j = 0; $j < $out->numCols(); $j++) {
        $out->set($j, $evalPts->item(0, $j) ** 2 + $evalPts->item(1, $j));
    }
    
    return $out;
}

################################################################################

return 1;

