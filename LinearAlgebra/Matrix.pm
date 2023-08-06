#!/usr/bin/perl

package Matrix;

use strict;
use warnings;


sub new {
    my $rows = shift;
    
    my $numRows = undef;
    my $numCols = undef;
    
    my $self = [$rows, $numRows, $numCols];
    bless($self);
    return $self;
}


sub rows {
    my $self = shift;
    my $rows = @{$self}[0];
    return $rows if defined $rows && ! scalar @_;
    if (defined $rows) {
        my @out = ();
        while (scalar @_) {
            push @out, @{$rows}[shift @_];
        }
        return \@out;
    }
    die "\nFailed to get the row(s) of the matrix.\n";
}


sub numRows {
    my $self = shift;
    my $numRows = @{$self}[1];
    return $numRows if defined $numRows;
    return scalar @{$self->rows()};
    die "\nFailed to get the number of rows.\n";
}


sub numCols {
    my $self = shift;
    my $numCols = @{$self}[2];
    return $numCols if defined $numCols;
    return scalar @{@{$self->rows()}[0]};
    die "\nFailed to get the number of columns.\n";
}


return 1;

