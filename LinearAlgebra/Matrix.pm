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


sub numRows {
    my $self = shift;
    my $numRows = @{$self}[0];
    return $numRows if defined $numRows;
    die "\nFailed to get the number of rows.\n";
}


sub numCols {
    my $self = shift;
    my $numCols = @{$self}[1];
    return $numCols if defined $numCols;
    die "\nFailed to get the number of columns.\n";
}


sub elements {
    my $self = shift;
    my $elements = @{$self}[2];
    return $elements if defined $elements && ! scalar @_;
    return @{@{$elements}[shift]}[shift] if defined $elements && (scalar @_) == 2;
    die "\nFailed to get the elements of the matrix.\n";
}
