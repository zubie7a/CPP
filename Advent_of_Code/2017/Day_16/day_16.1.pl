use strict;
use warnings;

my $instructions;
my $filename = 'input.txt';
open(my $file_in, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";
 
while (my $line = <$file_in>) {
    chomp $line;
    $instructions = [split ',', $line];
}

close($file_in);

my $seen = {};

# a: 0, b: 1 ... p: 15.
my $dancer_to_pos = { map { chr($_ + ord('a')) => $_ } (0 .. 15) };
my $pos_to_dancer = { map { $_ => chr($_ + ord('a')) } (0 .. 15) };

sub get_order {
    my $res = "";
    foreach my $pos (0 .. 15) {
        my $dancer = $pos_to_dancer->{$pos};
        $res .= $dancer;
    }
    return $res;
}

# Instructions: 
# sX: spin, rotate all positions to the right by X (increase everyone X
#     and then wrap around).
# xA/B: exchange, swap the programs at positions A and B.
# pA/B: partner, swap the positions of the programs A and B.
foreach my $instruction (@{ $instructions }) {
    my @capture;
    if (@capture = $instruction =~ /s(\d+)/) {
        my ($swap) = @capture;
        my $new_pos_to_dancer = {};
        foreach my $pos (keys %{ $pos_to_dancer }) {
            my $new_pos = ($pos + $swap) % 16;
            my $dancer = $pos_to_dancer->{$pos};
            $new_pos_to_dancer->{$new_pos} = $dancer;
            $dancer_to_pos->{$dancer} = $new_pos;
        }
        $pos_to_dancer = $new_pos_to_dancer;
    } elsif (@capture = $instruction =~ /x(\d+).(\d+)/ ) {
        my ($A, $B) = @capture;
        my $dancer_pos_a = $pos_to_dancer->{$A};
        my $dancer_pos_b = $pos_to_dancer->{$B};
        $dancer_to_pos->{$dancer_pos_a} = $B;
        $dancer_to_pos->{$dancer_pos_b} = $A;
        $pos_to_dancer->{$A} = $dancer_pos_b;
        $pos_to_dancer->{$B} = $dancer_pos_a;
    } elsif (@capture = $instruction =~ /p(\w+).(\w+)/ ) {
        my ($A, $B) = @capture;
        my $pos_dancer_a = $dancer_to_pos->{$A};
        my $pos_dancer_b = $dancer_to_pos->{$B};
        $pos_to_dancer->{$pos_dancer_b} = $A;
        $pos_to_dancer->{$pos_dancer_a} = $B;
        $dancer_to_pos->{$A} = $pos_dancer_b;
        $dancer_to_pos->{$B} = $pos_dancer_a;
    }
}

my $final_order = get_order();
# Result: olgejankfhbmpidc.
print "$final_order\n";
