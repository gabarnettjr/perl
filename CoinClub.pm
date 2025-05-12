
# Collection of functions for doing coin club stuff.
# Greg Barnett
# May 11, 2025

eval { use strict;   };
eval { use warnings; };

package CoinClub;

###############################################################################

sub writeNewMailingList
{
	die if scalar @_ != 2;
	my $mergeData = shift;
	my $newMailingListName = shift;
	
	(open CSV, ">$newMailingListName") || die;
	
	print CSV "Name,Email\n";
	
	foreach my $line (@{$mergeData})
	{
		print CSV "$$line{name},$$line{email}\n";
	}
	
	close CSV;
}

###############################################################################

sub mergeMailData
{
	die if scalar @_ != 2;
	my $twoColData = shift;
	my $tenColData = shift;
	
	my @newData = ();
	
	foreach my $line (@{$twoColData})
	{
		push @newData, $line;
	}
	
	foreach my $line (@{$tenColData})
	{
		$$line{name} = $$line{first}                if ! $$line{last};
		$$line{name} = $$line{last}                 if ! $$line{first};
		$$line{name} = "$$line{first} $$line{last}" if   $$line{first} && $$line{last};
		undef $$line{first};
		undef $$line{last};
		push @newData, $line;
	}
	
	my $newData = removeDuplicates(\@newData);
	return $newData;
}

###############################################################################

sub pullMailData
{
	die if scalar @_ != 2;
	my $fileName = shift;
	$numCols = shift;
	
	(open CSV, "<$fileName") || die;
	chomp (my @csv = <CSV>);
	close CSV;
	
	my @data = ();
	my $lineNumber = 0;
	
	foreach my $line (@csv)
	{
		$lineNumber++;
		
		if ($line =~ /\S+/ && $lineNumber != 1)
		{
			my @line = split /\s*\,\s*/, $line;
			my %line;
			
			if ($numCols == 2)
			{
				$line{name} = shift @line;
				$line{email} = shift @line;
			}
			elsif ($numCols == 10)
			{
				$line{first} = shift @line;
				$line{last} = shift @line;
				shift @line;
				shift @line;
				shift @line;
				shift @line;
				$line{email} = shift @line;
				shift @line;
				shift @line;
				shift @line;
			}
			else
			{
				die;
			}
			
			push @data, \%line if $line{email};
		}
	}
	
	my $data = removeDuplicates(\@data);
	return $data;
}

###############################################################################

sub writeNewPostalList
{
	die if scalar @_ != 2;
	my $listName = shift;
	my $data = shift;
	
	(open CSV, ">$listName") || die;
	print CSV "Intelligent Mail barcode,Opt. Endorsement Line,Full Name                   Sack and Pac,Delivery Address,\"City, St ZIP+4\"\n";
	
	foreach my $line (@{$data})
	{
		my @txt = ();
		push @txt, $$line{barcode};
		push @txt, $$line{endorsement};
		push @txt, $$line{fullName};
		push @txt, $$line{street};
		push @txt, $$line{city};
		push @txt, $$line{state};
		push @txt, $$line{zip};
		
		print CSV ((join ',', @txt) . "\n");
	}
	
	close CSV;
}

###############################################################################

sub combineData2025
{
	die if scalar @_ != 2;
	my $addressData = shift;
	my $emailData = shift;
	
	my @newData = ();
	print "\n";
	
	foreach my $addressLine (@{$addressData})
	{
		$$addressLine{solid} = 0;
		$$addressLine{maybe} = 0;
		
		foreach my $emailLine (@{$emailData})
		{
			if ($$emailLine{email} && $$addressLine{fullName} =~ /^$$emailLine{name}$/i)
			{
				# Solid cases:
				$$addressLine{solid}++;
				push @{$$addressLine{emails}}, $$emailLine{email};
				push @{$$addressLine{name}},  $$emailLine{name};
			}
			elsif ($$emailLine{email} && $$addressLine{fullName} =~ /$$emailLine{name}/i)
			{
				# Potentially troublesome:
				$$addressLine{maybe}++;
				push @{$$addressLine{emails}}, $$emailLine{email};
				push @{$$addressLine{name}},  $$emailLine{name};
			}
		}
		
		push @newData, $addressLine if ! ($$addressLine{solid} == 1 && ! $$addressLine{maybe});
	}
	
	print "\n\nTroublesome Cases:\n\n";
	my $troubleCount = 0;
	
	foreach my $addressLine (@{$addressData})
	{
		if ($$addressLine{maybe})
		{
			$troubleCount++;
			print $$addressLine{fullName} . "\n";
			
			for (my $i = 0; $i < scalar @{$$addressLine{emails}}; $i++)
			{
				print "@{$$addressLine{name}}[$i], @{$$addressLine{emails}}[$i]\n";
			}
			
			print "\n";
		}
	}
	
	print "Found $troubleCount troublesome case(s).\n\n";
	
	print "\n\nSolid Matches:\n\n";
	my $solidCount = 0;
	
	foreach my $addressLine (@{$addressData})
	{
		if ($$addressLine{solid} == 1 && ! $$addressLine{maybe})
		{
			$solidCount++;
			print $$addressLine{fullName} . "\n";
			
			for (my $i = 0; $i < scalar @{$$addressLine{emails}}; $i++)
			{
				print "@{$$addressLine{name}}[$i], @{$$addressLine{emails}}[$i]\n";
			}
			
			print "\n";
		}
	}
	
	print "Found $solidCount solid matches.\n";
	
	return \@newData;
}

###############################################################################

sub combineData2024
{
	die if scalar @_ != 2;
	my $addressData = shift;
	my $emailData = shift;
	
	my @newData = ();
	print "\n";
	
	foreach my $addressLine (@{$addressData})
	{
		$$addressLine{solid} = 0;
		$$addressLine{maybe} = 0;
		
		foreach my $emailLine (@{$emailData})
		{
			my $firstInitial = substr $$emailLine{first}, 0, 1;
			
			if ($$emailLine{email} && $$addressLine{fullName} =~ /^$$emailLine{first}\s+$$emailLine{last}/i)
			{
				# Solid cases:
				$$addressLine{solid}++;
				push @{$$addressLine{emails}}, $$emailLine{email};
				push @{$$addressLine{first}},  $$emailLine{first};
				push @{$$addressLine{last}}, $$emailLine{last};
			}
			elsif ($$emailLine{email} && $$addressLine{fullName} =~ /^$firstInitial\S+\s+.*$$emailLine{last}/i)
			{
				# Potentially troublesome:
				$$addressLine{maybe}++;
				push @{$$addressLine{emails}}, $$emailLine{email};
				push @{$$addressLine{first}},  $$emailLine{first};
				push @{$$addressLine{last}}, $$emailLine{last};
			}
		}
		
		push @newData, $addressLine if ! ($$addressLine{solid} == 1 && ! $$addressLine{maybe});
	}
	
	print "\n\nTroublesome Cases:\n\n";
	my $troubleCount = 0;
	
	foreach my $addressLine (@{$addressData})
	{
		if ($$addressLine{maybe})
		{
			$troubleCount++;
			print $$addressLine{fullName} . "\n";
			
			for (my $i = 0; $i < scalar @{$$addressLine{emails}}; $i++)
			{
				print "@{$$addressLine{last}}[$i], @{$$addressLine{first}}[$i], @{$$addressLine{emails}}[$i]\n";
			}
			
			print "\n";
		}
	}
	
	print "Found $troubleCount troublesome case(s).\n\n";
	
	print "\n\nSolid Matches:\n\n";
	my $solidCount = 0;
	
	foreach my $addressLine (@{$addressData})
	{
		if ($$addressLine{solid} == 1 && ! $$addressLine{maybe})
		{
			$solidCount++;
			print $$addressLine{fullName} . "\n";
			
			for (my $i = 0; $i < scalar @{$$addressLine{emails}}; $i++)
			{
				print "@{$$addressLine{last}}[$i], @{$$addressLine{first}}[$i], @{$$addressLine{emails}}[$i]\n";
			}
			
			print "\n";
		}
	}
	
	print "Found $solidCount solid matches.\n";
	
	return \@newData;
}

###############################################################################

sub pullAddressData
{
	die if scalar @_ != 1;
	my $listName = shift;
	
	(open CSV, "<$listName") || die;
	chomp (my @csv = <CSV>);
	close CSV;
	
	my @data = ();
	
	foreach my $line (@csv)
	{
		if ($line =~ /\S+/ && $line !~ /^Intelligent/)
		{
			my @line = split /\s*\,\s*/, $line;
			my %line;
			$line{barcode} = shift @line;
			$line{endorsement} = shift @line;
			$line{fullName} = shift @line;
			$line{street} = shift @line;
			$line{city} = shift @line;
			$line{city} =~ s/\"//;
			$line{state} = shift @line;
			my @stateZip = split /\s+/, $line{state};
			shift @stateZip while (! $stateZip[0]);
			$line{state} = shift @stateZip;
			$line{zip} = shift @stateZip;
			$line{zip} =~ s/\"//;
			
			push @data, \%line;
		}
	}
	
	# print ((scalar @data) . "\n");
	my $data = removeDuplicates(\@data);
	# print ((scalar @{$data}) . "\n");
	# exit;
	return $data;
}

###############################################################################

sub pullEmailData2025
{
	# This one uses the simpler email list that I noticed much later.
	die if scalar @_ != 1;
	my $listName = shift;
	
	(open CSV, "<$listName") || die;
	chomp (my @csv = <CSV>);
	close CSV;
	
	my @data = ();
	
	foreach my $line (@csv)
	{
		if ($line =~ /\S+/ && $line !~ /^Name/)
		{
			my @line = split /\s*\,\s*/, $line;
			
			my %line;
			$line{name} = shift @line;
			$line{email} = shift @line;
			
			push @data, \%line;
		}
	}
	
	# print ((scalar @data) . "\n");
	my $data = removeDuplicates(\@data);
	# print ((scalar @{$data}) . "\n");
	# exit;
	return $data;
}

###############################################################################

sub pullEmailData2024
{
	die if scalar @_ != 1;
	my $listName = shift;
	
	(open CSV, "<$listName") || die;
	chomp (my @csv = <CSV>);
	close CSV;
	
	my @data = ();
	
	foreach my $line (@csv)
	{
		if ($line =~ /\S+/ && $line !~ /^First/)
		{
			my @line = split /\s*\,\s*/, $line;
			
			my %line;
			$line{first} = shift @line;
			$line{last} = shift @line;
			$line{address} = shift @line;
			$line{city} = shift @line;
			$line{state} = shift @line;
			$line{zip} = shift @line;
			$line{email} = shift @line;
			$line{phone} = shift @line;
			$line{notes} = shift @line;
			$line{attend} = shift @line;
			
			push @data, \%line;
		}
	}
	
	# print ((scalar @data) . "\n");
	my $data = removeDuplicates(\@data);
	# print ((scalar @{$data}) . "\n");
	# exit;
	return $data;
}

###############################################################################

sub removeDuplicates
{
	die if scalar @_ != 1;
	my $data = shift;
	
	for (my $i = scalar @{$data} - 1; $i >= 0; $i--)
	{
		my @same = ();
		
		for (my $j = scalar @{$data} - 1; $j >= 0; $j--)
		{
			my $different = 0;
			
			if ($i != $j)
			{
				foreach my $k (keys %{@{$data}[$i]})
				{
					if (defined ${@{$data}[$j]}{$k} && defined ${@{$data}[$i]}{$k} && ${@{$data}[$i]}{$k} ne ${@{$data}[$j]}{$k})
					{
						$different = 1;
					}
				}
				
				if (! $different)
				{
					push @same, $j;
				}
			}
		}
		
		die if scalar @same > 1;
		
		if (scalar @same)
		{
			splice @{$data}, $same[0], 1;
		}
	}
	
	return $data;
}

###############################################################################

return 1;

