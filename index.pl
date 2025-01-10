use strict;
use warnings;
use GD;
use lib 'lib';
use Dungeon;
use Dungeon::Walker;

my $dungeon_map = Dungeon::Walker::walk();
my $outfile = "dungeon.png";
# create a new image
my %original_brown_td_shader = (
  r => 173,
  g => 121,
  b => 85
);

my %original_blue_td_shader = (
  r => 85,
  g => 137,
  b => 173
);

my $im = GD::Image->new($Dungeon::grid_size{width}, $Dungeon::grid_size{height});
# allocate some colors
my $white = $im->colorAllocate(255,255,255);
my $black = $im->colorAllocate(0,0,0);
$im->transparent($white);
$im->interlaced('true');

my %brown_scaler = (
  r => $original_brown_td_shader{r} * 0.02,
  g => $original_brown_td_shader{g} * 0.02,
  b => $original_brown_td_shader{b} * 0.02
);

my %blue_scaler = (
  r => $original_blue_td_shader{r} * 0.02,
  g => $original_blue_td_shader{g} * 0.02,
  b => $original_blue_td_shader{b} * 0.02
);

print $#$dungeon_map;

foreach my $row (0 .. $#$dungeon_map) {
  my %brown_td_shader = %original_brown_td_shader;
  my %blue_td_shader = %original_blue_td_shader;

  my $current_row = $dungeon_map->[$row];
  foreach my $col (0 .. $#$current_row) {
      my $brown = $im->colorResolve(
        int($brown_td_shader{r}),
        int($brown_td_shader{g}),
        int($brown_td_shader{b})
      ); 

      my $blue = $im->colorResolve(
        int($blue_td_shader{r}),
        int($blue_td_shader{g}),
        int($blue_td_shader{b})
      ); 
      
      if($current_row->[$col]) {
        $im->setPixel($col,$row,$brown);
      } else {
        $im->setPixel($col,$row,$blue);
      }

      $brown_td_shader{r} -= $brown_scaler{r};
      $brown_td_shader{g} -= $brown_scaler{g};
      $brown_td_shader{b} -= $brown_scaler{b};

      # Clamp color values to valid RGB range (0–255)
      $brown_td_shader{r} = 0 if $brown_td_shader{r} < 0;
      $brown_td_shader{g} = 0 if $brown_td_shader{g} < 0;
      $brown_td_shader{b} = 0 if $brown_td_shader{b} < 0;

      $blue_td_shader{r} -= $blue_scaler{r};
      $blue_td_shader{g} -= $blue_scaler{g};
      $blue_td_shader{b} -= $blue_scaler{b};

      # Clamp color values to valid RGB range (0–255)
      $blue_td_shader{r} = 0 if $blue_td_shader{r} < 0;
      $blue_td_shader{g} = 0 if $blue_td_shader{g} < 0;
      $blue_td_shader{b} = 0 if $blue_td_shader{b} < 0;
  }
}
   
#my $red = $im->colorAllocate(255,0,0);      
#my $blue = $im->colorAllocate(0,0,255);
# make the background transparent and interlaced
# $im->rectangle(0,0,99,99,$black);
# Draw a blue oval
# And fill it with red
#$im->fill(50,50,$red);
# make sure we are writing to a binary stream
open my $out, '>', $outfile or die "Cannot open $outfile: $!";
binmode $out;  # Required for binary output
print $out $im->png;
close $outfile;
# Convert the image to PNG and print it on standard output
#my $png_content = $im->png;