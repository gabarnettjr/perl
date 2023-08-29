#!/usr/bin/perl

package LocalPhs;

use strict;
use warnings;

use lib ".";
use Phs;

################################################################################

sub new {
    die "Requires four inputs.    " if scalar @_ != 4;
    my $dims = undef;
    my $rbfExponent = shift;
    my $polyDegree = shift;
    my $nodes = shift;
    my $vals = shift;
    my $splines = undef;
    
    my $self = ["LocalPhs", $dims, $rbfExponent, $polyDegree, $nodes, $vals, $splines];
    bless $self;
    return $self;
}

################################################################################

sub type {
    my $self = shift;
    return @{$self}[0];
}

################################################################################

sub dims {
    # Number of dimensions of the PHS (1, 2, 3, ...)
    my $self = shift;
    die "Too many inputs.    " if scalar @_;
    
    my $dims = @{$self}[1];
    return $dims if defined $dims;
    return $self->nodes()->numRows();
}

################################################################################

sub rbfExponent {
    my $self = shift;
    return @{$self}[2];
}

################################################################################

sub polyDegree {
    my $self = shift;
    return @{$self}[3];
}

################################################################################

sub nodes {
    my $self = shift;
    return @{$self}[4];
}

################################################################################

sub vals {
    my $self = shift;
    return @{$self}[5];
}

################################################################################

sub splines {
    my $self = shift;
    my $splines = @{$self}[6];
    return $splines if defined $splines;

    # Get the lower and upper bounds of the nodes in each dimension, to define the spatial domain.
    my $lowerBounds = Matrix::zeros($self->dims(), 1);
    my $upperBounds = Matrix::zeros($self->dims(), 1);
    for (my $i = 0; $i < $self->dims(); $i++) {
        $lowerBounds->set($i, $nodes->row($i)->min());
        $upperBounds->set($i, $nodes->row($i)->max());
    }

    
}

################################################################################

sub evaluate {
    my $self = shift;
    my $evalPts = shift;
    
    my $vals = [];
    
    foreach my $point ($evalPts) {
        foreach my $phs ($self->splines()) {
            if ($phs->smallBox()->contains($point)) {
                push(@{$vals}, $phs->evaluate($point));
            }
        }
    }
    
    return $vals;
}

################################################################################

return 1;

