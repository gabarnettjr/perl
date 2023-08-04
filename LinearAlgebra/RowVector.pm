#!/usr/bin/perl

use strict;
use warnings;

sub new {
    my $numElements = undef;
    my $elements = undef;
    my $self = [$numElements, $elements];
    bless $self;
    return $self ;
}

sub numElements {
    my $self = shift;
    my $numElements = @{$self}[0];
    return $numElements if defined $numElements;
    my $elements = $self->elements();
    return scalar @{$elements};
    die "Failed to get the number of elements.";
}
