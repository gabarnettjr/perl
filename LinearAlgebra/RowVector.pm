#!/usr/bin/perl

use strict;
use warnings;

sub new {
    my $numVals = undef;
    my $vals = undef;
    my $self = [$numVals, $vals];
    bless $self;
    return $self ;
}

sub numVals {
    my $self = shift;
    my $numVals = @{$self}[0];
    return $numVals if defined $numVals;
    my $vals = $self->vals();
    return scalar @{$vals};
    die "Failed to get the number of elements.";
}

sub vals {
    my $self = shift;
    my $vals = @{$self}[1];
    return $vals if defined $vals && ! (scalar @_);
    return @{$vals}[shift] if defined $vals;
    die "\nFailed to get the values of the row vector.\n";
}
