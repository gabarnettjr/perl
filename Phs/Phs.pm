#!/usr/bin/perl

package Phs;

use strict;
use warnings;



sub new {
    my $dims = shift;
    my $exponent = shift;
    my $nodes = shift;
    my $values = shift;
    
    my $coeffs = undef;
    
    my $self = [$dims, $exponent, $nodes, $values, $coeffs];
    bless $self;
    $self->coeffs();
    return $self;
}

################################################################################

sub dims {
    my $self = shift;
    my $dims = @{$self}[0];
    return $dims if defined $dims;
    print STDERR "\nFailed to get dimensions.\n";  die;
}



sub exponent {
    my $self = shift;
    my $exponent = @{$self}[1];
    return $exponent if defined $exponent;
    print STDERR "\nFailed to get exponent.\n";  die;
}



sub nodes {
    my $self = shift;
    my $nodes = @{$self}[2];
    return $nodes if defined $nodes && ! scalar @_;
    return @{$nodes}[shift] if defined $nodes;
    print STDERR "\nFailed to get the nodes.\n";  die;
}



sub values {
    my $self = shift;
    my $values = @{$self}[3];
    return $values if defined $values && ! scalar @_;
    return @{$values}[shift] if defined $values;
    print STDERR "\nFailed to get the function values at the nodes.\n";  die;
}



sub coeffs {
    my $self = shift;
    my $coeffs = @{$self}[5};
    return $coeffs if defined $coeffs && ! scalar @_;
    return $coeffs[shift] if defined $coeffs;
    
    my $A = Matrix::new($nodes->numCols(), $nodes->numCols());
    
    for (my $i = 0; $i < $nodes->numCols(); $i++) {
        for (my $j = 0; $j < $nodes->numCols(); $j++) {
            $A->set($i, $j, $self->phi($self->r($self->nodes()))->item($i, $j));
        }
    }
    
    my $values = $self->values()->transpose();
    $coeffs = $A->solve($values);
    
    return $coeffs->transpose();
}



sub r {
    my $self = shift;
    my $evalPts = shift;
    
    my $r = Matrix::new($evalPts->numCols(), $self->nodes()->numCols());
    
    for (my $i = 0; $i < $evalPts->numCols(); $i++) {
        for (my $j = 0; $j < $self->nodes()->numCols(); $j++) {
            my $tmp = 0;
            for (my $k = 0; $k < $self->dims(); $k++) {
                $tmp += ($evalPts->item($k, $i) - $nodes->item($k, $j)) ** 2;
            }
            $r->set($i, $j, (sqrt $tmp));
        }
    }
    
    return $r;
}



sub phi {
    my $self = shift;
    my $r = shift;
    
    my $phi = $r->copy();
    
    for (my $i = 0; $i < $phi->numRows(); $i++) {
        for (my $j = 0; $j < $phi->numCols(); $j++) {
            $phi->set($i, $j, $r->item($i, $j) ** $self->exponent());
        }
    }
    
    return $phi;
}



return 1;
