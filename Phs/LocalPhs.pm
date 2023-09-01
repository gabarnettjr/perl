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
    return $self->nodes->numRows;
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
    my $nodes = @{$self}[4];
    return $nodes if defined $nodes && ! scalar @_;
    return $nodes->col(shift) if defined $nodes;
    die "Failed to get nodes.";
}

################################################################################

sub vals {
    my $self = shift;
    my $vals = @{$self}[5];
    return $vals if defined $vals && ! scalar @_;
    return $vals->col(shift) if defined $vals;
    die "Failed to get function values.";
}

################################################################################

sub splines {
    my $self = shift;
    my $splines = @{$self}[6];
    return $splines if defined $splines && ! scalar @_;
    return @{$splines}[shift] if defined $splines;

    my @splines = ();

    for (my $j = 0; $j < $self->nodes->numCols; $j++) {
        my $stencil = $self->nodes->col($j);
        my $vals = $self->vals->col($j);
        for (my $k = 0; $k < $self->nodes->numCols; $k++) {
            if ($k != $j && ($self->nodes->col($j)->minus($self->nodes->col($k)))->norm < $self->stencilRadius) {
                $stencil = $stencil->hstack($self->nodes->col($k));
                $vals = $vals->hstack($self->vals->col($k));
            }
        }
        # print "dims = \(" . $vals->numRows . ", " . $vals->numCols . "\)\n";
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
    
    my ($min, $ind, $i, $j, $point, $node, $dist, $out);
    
    $out = Matrix::zeros(1, $evalPts->numCols);
    
    for ($i = 0; $i < $evalPts->numCols; $i++) {
        $point = $evalPts->col($i);
        $min = 99;
        for ($j = 0; $j < $self->nodes->numCols; $j++) {
            $node = $self->nodes->col($j);
            $dist = ($point->minus($node))->norm;
            if ($dist < $min) {
                $min = $dist;
                $ind = $j;
            }
        }
        # print "\$min = " . $point->minus($self->nodes->col($ind))->norm . "\n";
        # print "\$min = $min\n\n";
        # my $tmp = $self->splines($ind)->evaluate($point);
        # print "dims = " . $tmp->numRows . " x " . $tmp->numCols . "\n";
        $out->set($i, $self->splines($ind)->evaluate($point)->item(0));
    }
    
    return $out;
}

################################################################################

return 1;

