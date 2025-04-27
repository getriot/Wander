#!/usr/bin/perl

package Dungeon::Walker;

use strict;
use warnings;
use Cwd 'abs_path';
use File::Basename;

BEGIN {
    my $script_dir = dirname(abs_path("$0/.."));

    push @INC, $script_dir;
}

use parent 'Dungeon';

my $gs = get_grid_size();

our $max_steps = ($gs->{width} - ($Dungeon::grid_padding * 2)) * ($gs->{height} - ($Dungeon::grid_padding * 2));

our %starting_point = (
  x => $Dungeon::grid_size{width} / 2,
  y => $Dungeon::grid_size{height} / 2
);

our $altitude = 0;

our %current_position = (
  x => $Dungeon::Walker::starting_point{x},
  y => $Dungeon::Walker::starting_point{y}
);

our @directions = ("UP", "DOWN", "LEFT", "RIGHT"); 

sub walk {
  for(my $i = 0; $i < $max_steps; $i++) {
    my $direction = choose_random_direction();
    my $direction_vector = direction_to_vector($direction);

    if(can_walk($direction_vector)) {
      step($direction_vector);
      Dungeon::toggle_cell(%Dungeon::Walker::current_position);
    }
  }

  my $grid = Dungeon::get_grid();

  return \@$grid; 
}

sub step {
  my ($direction) = @_;

  %Dungeon::Walker::current_position = (
    x => $Dungeon::Walker::current_position{x} + @$direction{x},
    y => $Dungeon::Walker::current_position{y} + @$direction{y}
  );

  return \%Dungeon::Walker::current_position;
}

sub choose_random_direction {
  # Generate a random number between $min and $max
  my $random_dir_index = int(rand((scalar @directions - 1) + 1));
  return $Dungeon::Walker::directions[$random_dir_index];
}

sub direction_to_vector {
  my ($direction) = @_;
  
  if ($direction eq "UP") {
    return {
      x => 0,
      y => 1
    };
  } elsif ( $direction eq "DOWN") {
    return {
      x => 0,
      y => -1
    };
  } elsif ( $direction eq "LEFT") {
    return {
      x => -1,
      y => 0
    };
  } elsif ( $direction eq "RIGHT") {
    return {
      x => 1,
      y => 0
    };
  }

  return undef;
}

sub can_walk {
  my ($direction) = @_;

  my %movement_result = (
    x => 0,
    y => 0
  );

  %movement_result = (
    x => $direction->{x} + $Dungeon::Walker::current_position{x},
    y => $direction->{y} + $Dungeon::Walker::current_position{y}
  );

  if(
    $movement_result{"x"} > $Dungeon::grid_size{height} - $Dungeon::grid_padding or
    $movement_result{"y"} > $Dungeon::grid_size{width} - $Dungeon::grid_padding or
    $movement_result{"x"} < $Dungeon::grid_padding or
    $movement_result{"y"} < $Dungeon::grid_padding
  ) {
    return 0;
  }
  return 1;
}

sub get_grid_size {
  my $grid_size = Dungeon::get_grid_size();

  return $grid_size;
}

1;


my @final_path = walk();
print @final_path;