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



sub $nodes {
    my $self = shift;
    my $nodes = @{$self}[2];
    return $nodes if defined $nodes && ! scalar @_;
    return $nodes[shift] if defined $nodes;
}



return 1;
