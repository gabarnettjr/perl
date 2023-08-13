#!/usr/bin/perl

package Phs;

use strict;
use warnings;

sub new {
    my $dims = shift;
    my $exponent = shift;
    my $nodes = shift;
    
    my $evalPts = undef;
    my $coeffs = undef;
    
    my $self = [$dims, $exponent, $nodes, $evalPts, $coeffs];
    bless $self;
    return $self;
}

return 1;
