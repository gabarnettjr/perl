#!/usr/bin/perl

package Matrix;

use strict;
use warnings;


sub new {
    my $rows = shift;
    
    my $numRows = undef;
    my $numCols = undef;
    
    my $self = [$rows, $numRows, $numCols];
    bless $self;
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


sub dot {
    # Return the dot product of two 1D arrays of the same size.
    my $self = shift;
    my $other = shift;
    
    my $dot = 0;
    
    my $numRows = $self->numRows();
    my $numCols = $self->numCols();
    if ($numRows != $other->numRows() || $numCols != $other->numCols()) {
        die "\nArrays must be the same size to dot them.\n";
    } elsif ($numRows != 1 && $numCols != 1) {
        die "\nThis function is only implemented for 1D arrays.\n";
    } elsif ($numRows == 1) {
        for (my $j = 0; $j < $numCols; $j++) {
            $dot += $self->item(0, $j) * $other->item(0, $j);
        }
    } elsif ($numCols == 1) {
        for (my $i = 0; $i < $numRows; $i++) {
            $dot += $self->item($i, 0) * $other->item($i, 0);
        }
    }
    
    return $dot;
}


sub mult {
    # Multiply a matrix by a scalar, or multiply two matrices.
    my $self = shift;
    my $other = shift;
    
    my @out = ();
    
    if (ref $other) {
        # TODO: NEED TO ADD TRANSPOSE FUNCTION BEFORE ADDING THIS PART.
    } else {
        for (my $i = 0; $i < $self->numRows(); $i++) {
            my @tmp = ();
            for (my $j = 0; $j < $self->numCols(); $j++) {
                push(@tmp, $other * $self->item($i, $j));
            }
            push(@out, \@tmp);
        }
    }
    
    my $prod = Matrix::new(\@out);
    return $prod;
}


return 1;

