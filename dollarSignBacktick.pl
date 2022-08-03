#!/mu/bin/perl

use strict;

my ($mirror, $lyn, @jobd, $tmp, $tmp1);

@jobd = ("Hello", "OPTION PA,M,VA=10", "Goodbye");

## Sample OPTION line:  OPTION PA,M,VA=10
$mirror = 0;
foreach $lyn (@jobd) {			# Find uncommented global mirror command in job deck, if any.
	if ($lyn =~ /^CHIP/) { last; }
	if (($lyn =~ /OPTION/) && ($lyn =~ /M/) && ($lyn !~ /\*/)) {
		$mirror = 1;
		last;
	}
	# if (($lyn =~ /OPTION/) && ($lyn =~ /M/)) {
		# if ($lyn !~ /\*/) {
			# $mirror = 1;
			# last;
		# } elsif ($lyn =~ /\*/) {
			# $lyn =~ /OPTION/;
			# $tmp = length($`);
			# print($`);
			# if ($tmp == 0) {
				# $mirror = 1;
				# last;
			# } else {
				# $lyn =~ /\*/;
				# $tmp1 = length($`);
				# if ($tmp1 > $tmp) {
					# $mirror = 1;
					# last;
				# }
			# }
		# }
	# }
}
print("\$mirror = $mirror");
