#!/usr/bin/perl

package Subdomain;

use strict;
use warnings;

use lib "../LinearAlgebra";
use Matrix;

################################################################################

sub new {
    die "Required number of inputs is 1.    " if scalar @_ != 1;
    my $bounds = shift;
    my $center = undef;
    my $nodes = undef;
    my $halfWidths = undef;
    
    my $self = ["Subdomain", $bounds, $center, $nodes, $halfWidths];
    bless $self;
    return $self;
}

################################################################################

sub type {
    my $self = shift;
    my $type = @{$self}[0];
    return $type if defined $type;
    die "Failed to determine object type, which should be \"Subdomain\".";
}

################################################################################

sub bounds {
    my $self = shift;
    die "This function takes no inputs.    " if scalar @_ != 0;
    my $bounds = @{$self}[1];
    return $bounds if defined $bounds;
    die "Failed to get subdomain bounds.";
}

################################################################################

sub center {
    my $self = shift;
    die "This function takes no inputs.    " if scalar @_ != 0;
    my $center = @{$self}[2];
    return $center if defined $center;
    
    eval {
        $center = Matrix::zeros(1, $self->bounds()->numCols());
        for (my $j = 0; $j < $center->numCols(); $j++) {
            $center->set($j, ($self->bounds()->item(0, $j) + $self->bounds()->item(1, $j)) / 2);
        }
    };
    die if $@;
    
    @{$self}[1] = $center;
    return $center;
}

################################################################################

sub nodes {
    my $self = shift;
    my $nodes = @{$self}[3];
    return $nodes if defined $nodes;
    
    die "Requires parent nodes as input.    " if scalar @_ != 1;
    my $parentNodes = shift;
    
    my ($closeEnough, $diff, $nodes);
    
    eval {
        $nodes = Matrix::zeros($parentNodes->numRows(), 0);
    };
    die if $@;
    
    for (my $j = 0; $j < $parentNodes->numCols(); $j++) {
        $closeEnough = 1;
        my $tmp = Matrix::zeros($parentNodes->numRows(), 1);
        for (my $i = 0; $i < $parentNodes->numRows(); $i++) {
            $diff = $parentNodes->item($i, $j) - $self->center()->item($j);
            if ((abs $diff) > $self->halfWidths()->item($j)) {
                $closeEnough = 0;
                last;
            } else {
                $tmp->set($i, $parentNodes->item($i, j));
            }
        }
        eval {
            $nodes = $nodes->hstack($tmp) if $closeEnough;
        };
        die if $@;
    }
}

################################################################################

sub halfWidths {
    my $self = shift;
    my $halfWidths = @{$self}[4];
    return $halfWidths if defined $halfWidths;
    
    $halfWidths = Matrix::zeros(1, $self->bounds()->numCols());
    for (my $j = 0; $j < $halfWidths->numCols(); $j++) {
        $halfWidths->set($j, ($self->bounds()->item(1, $j) - $self->bounds()->item(0, $j)) / 2);
    }
    
    @{$self}[4] = $halfWidths;
    return $halfWidths;
}

################################################################################

return 1;

