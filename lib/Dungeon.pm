package Dungeon;

use Data::Dumper;

our %grid_size = (
  width => 50,
  height => 50
);

our @grid = map { [ (0) x 50 ] } (0..49);
  
our $grid_padding = 1;

sub toggle_cell {
  my (%cell) = @_;

  if (
    $cell{x} >= 0 && $cell{x} < $grid_size{width} &&
    $cell{y} >= 0 && $cell{y} < $grid_size{height}
  ) {
    $grid[$cell{x}][$cell{y}] = 1;
  } else {
    die "\n[Error] - Cell out of bounds";
  }

  return $Dungeon::grid[$cell{x}][$cell{y}];
}

sub get_grid {
  return \@Dungeon::grid;
}

sub get_grid_size {
  return \%Dungeon::grid_size;
}

1;