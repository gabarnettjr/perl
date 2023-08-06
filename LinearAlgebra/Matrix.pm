#!/usr/bin/perl

package Matrix;

use strict;
use warnings;

################################################################################

sub new {
    my ($items, $numRows, $numCols);
    if (scalar @_ == 1 && ref $_[0]) {
        $items = shift;
        $numRows = scalar @{$items};
        $numCols = scalar @{@{$items}[0]};
    } elsif (scalar @_ == 2 && ! ref $_[0] && ! ref $_[1]) {
        $numRows = shift;
        $numCols = shift;
        my @items = ();
        for (my $i = 0; $i < $numRows; $i++) {            
            my @tmp = ();
            for (my $j = 0; $j < $numCols; $j++) {
                push(@tmp, 0);
            }
            push(@items, \@tmp);
        }
        $items = \@items;
    } else {
        print "\nBad input for new matrix.  Give ref to array or dimensions.\n";
        die;
    }
    
    my $self = [$items, $numRows, $numCols];
    bless $self;
    return $self;
}

################################################################################

sub items {
    my $self = shift;
    my $items = @{$self}[0];
    return $items if defined $items && ! scalar @_;
    print "\nFailed to get the items in the matrix.\n";
    die;
}

################################################################################

sub numRows {
    my $self = shift;
    my $numRows = @{$self}[1];
    return $numRows if defined $numRows;
    print "\nFailed to get the number of rows.\n";
    die;
}

################################################################################

sub numCols {
    my $self = shift;
    my $numCols = @{$self}[2];
    return $numCols if defined $numCols;
    print "\nFailed to get the number of columns.\n";
    die;
}

################################################################################

sub disp {
    my $self = shift;
    foreach my $row (@{$self->items()}) {
        foreach my $item (@{$row}) {
            printf "%3i ", $item;
        }
        print "\n";
    }
}

################################################################################

sub item {
    my $self = shift;
    my $i = shift;
    my $j = shift;
    
    if ($self->numRows() != 1 && $self->numCols() != 1 || defined $i && defined $j) {
        return @{@{$self->items()}[$i]}[$j];
    } elsif ($self->numRows() == 1) {
        return @{@{$self->items()}[0]}[$i];
    } elsif ($self->numCols() == 1) {
        return @{@{$self->items()}[$i]}[0];
    }
}

################################################################################

sub row {
    my $self = shift;
    my $i = shift;
    
    my $row = @{$self->items()}[$i];
    my $out = Matrix::new([$row]);
    
    return $out;
}

################################################################################

sub set {
    my $self = shift;
    my $i = shift;
    my $j = shift;
    my $val = shift;
    
    @{@{$self->items()}[$i]}[$j] = $val;
}

################################################################################

sub plus {
    my $self = shift;
    my $other = shift;
    
    my $numRows = $self->numRows();
    my $numCols = $self->numCols();
    
    if (ref $other && ($numRows != $other->numRows() || $numCols != $other->numCols())) {
        print "\nMatrices must be the same size to add them together.\n";
        die;
    }
    
    my $sum = Matrix::new($numRows, $numCols);
    
    for (my $i = 0; $i < $numRows; $i++) {
        for (my $j = 0; $j < $numCols; $j++) {
            if (ref $other) {
                $sum->set($i, $j, $self->item($i, $j) + $other->item($i, $j));
            } else {
                $sum->set($i, $j, $self->item($i, $j) + $other);
            }
        }
    }
    
    return $sum;
}

################################################################################

sub dot {
    # Return the dot product of two 1D arrays of the same size.
    my $self = shift;
    my $other = shift;
    
    my $dot = 0;
    
    my $numRows = $self->numRows();
    my $numCols = $self->numCols();
    
    if ($numRows != $other->numRows() || $numCols != $other->numCols()) {
        print "\nArrays must be the same size to dot them.\n";
        die;
    } elsif ($numRows != 1 && $numCols != 1) {
        print "\nThis function is only implemented for 1D arrays.\n";
        die;
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

################################################################################

sub transpose {
    my $self = shift;
    
    my $out = Matrix::new($self->numCols(), $self->numRows());
    
    for (my $i = 0; $i < $out->numRows(); $i++) {
        for (my $j = 0; $j < $out->numCols(); $j++) {
            $out->set($i, $j, $self->item($j, $i));
        }
    }
    
    return $out;
}

################################################################################

sub times {
    # Multiply a matrix by a scalar, or by another matrix.
    my $self = shift;
    my $other = shift;
    
    my $prod;
    
    if (ref $other) {
        if ($self->numCols() != $other->numRows()) {
            print "\n\$numCols of first matrix (" . $self->numCols() . ") must equal \$numRows of second (" . $other->numRows() . ").\n";
            print "\$first = \n";
            $self->disp();
            print "\n";
            print "\$second = \n";
            $other->disp();
            die;
        }
        $prod = Matrix::new($self->numRows(), $other->numCols());
        $other = $other->transpose();
        for (my $i = 0; $i < $prod->numRows(); $i++) {
            for (my $j = 0; $j < $prod->numCols(); $j++) {
                $prod->set($i, $j, $self->row($i)->dot($other->row($j)));
            }
        }
    } else {
        $prod = Matrix::new($self->numRows(), $self->numCols());
        for (my $i = 0; $i < $self->numRows(); $i++) {
            for (my $j = 0; $j < $self->numCols(); $j++) {
                $prod->set($i, $j, $other * $self->item($i, $j));
            }
        }
    }
    
    return $prod;
}

################################################################################

sub dotTimes {
    my $self = shift;
    my $other = shift;
    
    my $numRows = $self->numRows();
    my $numCols = $self->numCols();
    
    if ($numRows != $other->numRows() || $numCols != $other->numCols()) {
        print "\nMatrices must be the same size to (dot) multiply them together.\n";
        die;
    }
    
    my $prod = Matrix::new($numRows, $numCols);
    
    for (my $i = 0; $i < $numRows; $i++) {
        for (my $j = 0; $j < $numCols; $j++) {
            $prod->set($i, $j, $self->item($i, $j) * $other->item($i, $j));
        }
    }
    
    return $prod;
}

################################################################################

return 1;

