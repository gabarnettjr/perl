#!/usr/bin/perl

use strict;
use warnings;

sub new {
    my $numElements = undef;
    my $elements = undef;
    my $self = [$numElements, $elements];
    bless($self);
    return($self);
}
