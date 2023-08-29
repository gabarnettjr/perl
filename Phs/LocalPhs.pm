#!/usr/bin/perl

package LocalPhs;

use strict;
use warnings;

use lib ".";
use Phs;
use Subdomain;

################################################################################

sub new {
    die "Requires four inputs.    " if scalar @_ != 4;
    my $dims = undef;
    my $rbfExponent = shift;
    my $polyDegree = shift;
    my $nodes = shift;
    my $values = shift;
    my $splines = undef;
    
    my $self = ["LocalPhs", $dims, $rbfExponent, $polyDegree, $nodes, $values, $splines];
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

}

################################################################################

sub splines {
    my $self = shift;
    my $splines = @{$self}[1];
    return $splines if defined $splines;
    
    
}

################################################################################

sub evaluate {
    my $self = shift;
    my $evalPts = shift;
    
    my $values = [];
    
    foreach my $point ($evalPts) {
        foreach my $phs ($self->splines()) {
            if ($phs->smallBox()->contains($point)) {
                push(@{$values}, $phs->evaluate($point));
            }
        }
    }
    
    return $values;
}

################################################################################

return 1;

