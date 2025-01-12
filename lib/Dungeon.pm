package Dungeon;

our %grid_size = (
  width => 1920,
  height => 1080
);

our @grid = map { [ (0) x $Dungeon::grid_size{width} ] } (0..$Dungeon::grid_size{height});
our @heightmap = map { [ (0) x $Dungeon::grid_size{width} ] } (0..$Dungeon::grid_size{height});
our @heightmap_ops = (-1, 0, 1); 
our @current_altitude = 0;

our $grid_padding = 10;

sub toggle_cell {
  my (%cell) = @_;

  if (
    $cell{x} >= 0 && $cell{x} < $grid_size{width} &&
    $cell{y} >= 0 && $cell{y} < $grid_size{height}
  ) {
    $grid[$cell{y}][$cell{x}] = 1;
    $heightmap[$cell{y}][$cell{x}] = Dungeon::random_change_altitude();
  } else {
    die "\n[Error] - Cell out of bounds";
  }

  return $Dungeon::grid[$cell{y}][$cell{x}];
}


sub random_change_altitude {
  my $random_altitude = int(rand((49 - 1) + 1));
  return $random_altitude;
}

sub get_grid {
  return \@Dungeon::grid;
}

sub get_grid_size {
  return \%Dungeon::grid_size;
}
sub get_heightmap {
  return \@Dungeon::heightmap;
}

1;