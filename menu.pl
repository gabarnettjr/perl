#!/usr/bin/perl

# An interactive menu with sub-menus.
# Greg Barnett
# December 2024

use strict;
use warnings;

###############################################################################

my @main = ('fruits', 'vegetables');

my @fruits = ('apples', 'oranges');
	my @apples = ('honeycrisp', 'granny smith', 'gala');
	my @oranges = ('bahia', 'valencia', 'jaffa');

my @vegetables = ('carrots', 'cucumbers');
	my @carrots = ('imperator', 'danvers', 'purple', 'yellow');
		my @imperator = (imperator());
	my @cucumbers = ('lemon', 'armenian', 'english');

menu(\@main);

###############################################################################

sub menu
{
	my $items = shift;
	my $count = 1;
	my $input = -1;
	
	clearScreen();
	print "(0) Exit.\n";
	
	if (scalar @{$items} > 1)
	{
		foreach my $item (@{$items})
		{
			print "($count) $item\n";
			$count++;
		}
	}
	elsif (scalar @{$items} == 1)
	{
		print @{$items}[0] . "\n";
		exit;
	}
	
	chomp ($input = <STDIN>);
	exit if $input == 0;
	$count = 1;
	
	foreach my $item (@{$items})
	{
		if ($count == $input)
		{
			eval "menu(\\\@$item)";
		}
		else
		{
			$count++;
		}
	}
	
	exit;
}

###############################################################################

sub imperator
{
	return 'From the internet: Imperator carrots are a common variety of carrot that are long, straight, and tapered, with a deep orange color and thin skin.';
}

###############################################################################

sub clearScreen
{
	if ($^O =~ /win/i)
	{
		system "cls";
	}
	else
	{
		system "clear";
	}
}

###############################################################################
