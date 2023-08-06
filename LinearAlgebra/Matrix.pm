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

################################################################################

sub disp {
    my $self = shift;
    foreach my $row (@{$self->rows()}) {
        foreach my $item (@{$row}) {
            print "$item ";
        }
        print "\n";
    }
}


sub item {
    my $self = shift;
    
    my $i = shift;
    my $j = shift;
    
    if ($self->numRows() != 1 && $self->numCols() != 1 || (defined $i) && (defined $j)) {
        return @{@{$self->rows()}[$i]}[$j];
    } elsif ($self->numRows() == 1) {
        return @{@{$self->rows()}[0]}[$i];
    } elsif ($self->numCols() == 1) {
        return @{@{$self->rows()}[$i]}[0];
    }
}


sub add {
    my $self = shift;
    my $other = shift;
    
    my $numRows = $self->numRows();
    my $numCols = $self->numCols();
    if ($numRows != $other->numRows() || $numCols != $other->numCols()) {
        die "\nMatrices must be the same size to add them together.\n";
    }
    
    my @out = ();
    for (my $i = 0; $i < $numRows; $i++) {
        my @tmp = ();
        for (my $j = 0; $j < $numCols; $j++) {
            push(@tmp, $self->item($i, $j) + $other->item($i, $j));
        }
        push(@out, \@tmp);
    }
    
    my $sum = Matrix::new(\@out);
    return $sum;
}


return 1;

