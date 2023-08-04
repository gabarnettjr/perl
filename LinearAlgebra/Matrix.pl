#!/usr/bin/perl

use strict;
use warnings;

sub new {
    my $numRows = undef;
    my $numCols = undef;
    my $elements = undef;
    my $rows = undef;
    my $columns = undef;
    my $self = [$numRows, $numCols, $elements, $rows, $columns];
    bless(self);
    return $self;
}
