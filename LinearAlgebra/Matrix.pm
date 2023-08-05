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


sub rows {
    my $self = shift;
    my $rows = @{$self}[2];
    return $rows if defined $rows && ! scalar @_;
    return @{$rows}[shift] if defined $rows && (scalar @_) == 1;
    return @{@{$rows}[shift]}[shift] if defined $rows && (scalar @_) == 2;
    die "\nFailed to get the row(s) of the matrix.\n";
}
