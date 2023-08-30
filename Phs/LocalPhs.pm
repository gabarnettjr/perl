#!/usr/bin/perl

package LocalPhs;

use strict;
use warnings;

use lib ".";
use Phs;

################################################################################

sub new {
    die "Requires five inputs.    " if scalar @_ != 5;
    my $dims = undef;
    my $rbfExponent = shift;
    my $polyDegree = shift;
    my $nodes = shift;
    my $vals = shift;
    my $splines = undef;
    my $stencilRadius = shift;
    
    my $self = ["LocalPhs", $dims, $rbfExponent, $polyDegree, $nodes, $vals, $splines, $stencilRadius];
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
    return $splines if defined $splines && ! scalar @_;
    return @{$splines}[shift] if defined $splines;

    my @splines = ();

    for (my $j = 0; $j < $self->nodes->numCols; $j++) {
        # my $stencil = Matrix::zeros($self->dims, 0);
        my $stencil = $self->nodes->col($j);
        my $vals = Matrix::zeros(1, 0);
        for (my $k = 0; $k < $self->nodes->numCols; $k++) {
            if ($k != $j && ($self->nodes->col($j)->minus($self->nodes->col($k)))->norm < $self->stencilRadius) {
                $stencil = $stencil->hstack($self->nodes->col($k));
                $vals = $vals->hstack($self->vals($k));
            }
        }
        my $phs = Phs::new($self->rbfExponent, $self->polyDegree, $stencil, $vals);
        push(@splines, $phs);
    }
    
    @{$self}[6] = \@splines;
    return \@splines if ! scalar @_;
    return $splines[shift];
}

################################################################################

sub stencilRadius {
    my $self = shift;
    return @{$self}[7];
}

################################################################################

sub evaluate {
    my $self = shift;
    my $evalPts = shift;
    
    my $vals = Matrix::zeros(1, $evalPts->numCols);
    my ($min, $ind, $i, $j, $point, $node, $dist);
    
    for ($i = 0; $i < $evalPts->numCols; $i++) {
        $point = $evalPts->col($i);
        $min = 99;
        for ($j = 0; $j < $self->nodes->numCols; $j++) {
            $node = $self->nodes->col($j);
            $dist = $point->minus($node)->norm;
            if ($dist < $min) {
                $min = $dist;
                $ind = $j;
            }
        }
        $vals->set($i, $self->splines($ind)->evaluate($point->transpose));
    }
    
    return $vals;
}

################################################################################

return 1;

