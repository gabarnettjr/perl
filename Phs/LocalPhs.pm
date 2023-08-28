#!/usr/bin/perl

package LocalPhs;

use strict;
use warnings;

use lib ".";
use Phs;
use Subdomain;

################################################################################

sub new {
    die "Requires one input (the nodes).    " if scalar @_ != 1;
    my $dims = undef;
    my $rbfExponent = shift;
    my $polyDegree = shift;
    my $nodes = shift;
    my $values = shift;
    my $splines = undef;
    my $subdomains = undef;
    
    my $self = ["LocalPhs", $nodes, $splines, $subdomains];
    bless $self;
    return $self;
}

################################################################################

sub type {
    my $self = shift;
    return @{$self}[0];
}

################################################################################

sub splines {
    my $self = shift;
    my $splines = @{$self}[1];
    return $splines if defined $splines;
    
    
}

################################################################################

sub subdomains {
    my $self = shift;
    my $subdomains = @{$self}[2];
    return $subdomains if defined $subdomains;
    
    
}

################################################################################

sub eval {
    my $self = shift;
    my $evalPts = shift;
    
    my $values = [];
    
    foreach my $point ($evalPts) {
        foreach my $phs ($self->splines()) {
            if ($phs->subdomain()->contains($point)) {
                push(@{$values}, $phs->eval($point));
            }
        }
    }
    
    return $values;
}

################################################################################

return 1;

