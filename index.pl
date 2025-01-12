use strict;
use warnings;
use GD;
use lib 'lib';
use Dungeon;
use Dungeon::Walker;

my $outfile = "dungeon.png";

my $dungeon_map = Dungeon::Walker::walk();
my $dungeon_heightmap = Dungeon::get_heightmap();

my $im = GD::Image->new($Dungeon::grid_size{width}, $Dungeon::grid_size{height});
my $white = $im->colorAllocate(255,255,255);
$im->transparent($white);
$im->interlaced('true');

my %original_brown_td_shader = (
  r => 127,
  g => 120,
  b => 99
);
my %original_blue_td_shader = (
  r => 115,
  g => 127,
  b => 126
);
my %original_black_alpha_shader = (
  r => 85,
  g => 137,
  b => 173
);

my %brown_td_shader = %original_brown_td_shader;
my %blue_td_shader = %original_blue_td_shader;

my @brown = ($brown_td_shader{r}, $brown_td_shader{g}, $brown_td_shader{b});
my @blue = ($blue_td_shader{r}, $blue_td_shader{g}, $blue_td_shader{b});
my @black = (86, 60, 43);
my @dark_blue = (71, 80, 80);
my @dark_brown = (118, 70, 30);

for(my $row = 0; $row <= $#$dungeon_map; $row++) {
  my $current_row = $dungeon_map->[$row];
  
  for(my $col = 0; $col <= $#$current_row; $col++) {
      my ($r, $g, $b) = (0, 0, 0);
      
      if($current_row->[$col]) {
        ($r, $g, $b) = interpolate_color($dungeon_heightmap->[$row]->[$col], 0, 49, \@black, \@brown);
      } else {
        $dungeon_heightmap->[$row]->[$col] = Dungeon::random_change_altitude();
        ($r, $g, $b) = interpolate_color($dungeon_heightmap->[$row]->[$col], 0, 49, \@blue, \@dark_blue);
      }

      if(defined $current_row->[$col - 1]) {
        if($current_row->[$col - 1] and
          (
            $dungeon_map->[$row - 1]->[$col] and
            $dungeon_map->[$row + 1] ->[$col] and
            $dungeon_map->[$row]->[$col+1]
          )
        ) {
          if($current_row->[$col]) {
            ($r, $g, $b) = interpolate_color(50, 0, 100, \@brown, [$r, $g, $b]);
          } else {
            ($r, $g, $b) = @dark_brown;
          }
        } else {
          if($current_row->[$col]) {
            ($r, $g, $b) = @dark_brown;
          } else {
            ($r, $g, $b) = interpolate_color(50, 0, 100, \@blue, [$r, $g, $b]);
          }
        }
      }

      my $color = $im->colorResolve(
        $r,
        $g,
        $b
      ); 

      $im->setPixel($col, $row, $color);
  }
}

sub interpolate_color {
    my ($value, $min, $max, $color1, $color2) = @_;
    my $ratio = ($value - $min) / ($max - $min);

    my $r = int($color1->[0] + ($color2->[0] - $color1->[0]) * $ratio);
    my $g = int($color1->[1] + ($color2->[1] - $color1->[1]) * $ratio);
    my $b = int($color1->[2] + ($color2->[2] - $color1->[2]) * $ratio);

    return ($r, $g, $b);
}

sub color_to_array {
  my ($color) = @_;

  return ($color->{r}, $color->{g}, $color->{b}) 
}

sub colorarray_to_color {
  my ($color_array) = @_;

  return (
    r => $color_array->[0],
    g => $color_array->[1],
    b => $color_array->[2]
  );
}
   
#my $red = $im->colorAllocate(255,0,0);      
#my $blue = $im->colorAllocate(0,0,255);
# make the background transparent and interlaced
# $im->rectangle(0,0,99,99,$black);
# Draw a blue oval
# And fill it with red
#$im->fill(50,50,$red);
# make sure we are writing to a binary stream
open my $out, '>', $outfile || die "Cannot open $outfile: $!";
binmode $out;  # Required for binary output
print $out $im->png;
close $outfile;
# Convert the image to PNG and print it on standard output
#my $png_content = $im->png;