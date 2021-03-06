use strict;
use warnings;

# Test starting values:
# my ($gen_a, $gen_b) = (65, 8921);
# Result: 309.

# Starting values.
my ($gen_a, $gen_b) = (116, 299);
# Factor to multiply by each generator.
my ($x_a, $x_b) = (16807, 48271);

# 2^31 - 1.
my ($mod) = (1 << 31) - 1;

# At each iteration a judge will evaluate the last 16 bits of both
# generators and increase by 1 this count if the 16 bits match.
my $judge_count = 0;

# Create two bit masks to have sixteen ones, so:
#
#   1000000000000000 - 1 = 0111111111111111.
#
# This will help extract the last 16 bits of the generator
# values with bitwise &, then they can be compared directly
# as integer values. 
my $mask = (1 << 16) - 1;

# FIVE MILLION ITERATIONS.
for (1 .. 5000000) {
    # Keep multiplying by the factor but also apply mod to keep
    # it from overflowing. But now also keep multiplying each
    # generator individually until the result is divisible by
    # 4 for $gen_a and 8 for $gen_b.
    do {
        $gen_a = ($gen_a * $x_a) % $mod;
    } while ($gen_a % 4);

    do {
        $gen_b = ($gen_b * $x_b) % $mod;
    } while ($gen_b % 8);

    # Compare if the last 16 bits are the same.
    my $bits_a = $gen_a & $mask;
    my $bits_b = $gen_b & $mask;

    # DEBUG: printf("%.16b\n%.16b\n\n", $bits_a, $bits_b);
    $judge_count += ($bits_a == $bits_b);
}

# Result: 298.
print "$judge_count\n";
