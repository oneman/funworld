#!/usr/bin/env ruby 

# map tool
# 2006 drr
# all rights negated

require 'conf'
require 'map'

class Maptool
  
def initialize
  puts "\nwelcome to maptool\n"
  menu
end
  
def menu
  puts ""
  puts "n) new map"
  puts "l) load map"
  if @map != nil
   puts "s) save map"
   puts "z) clear map"
   puts "c) generate land"
   puts "i) generate island"
   puts "e) edit tile"
  end
  puts "q) quit"
  print "maptool> "
  option = STDIN.gets.chomp
  puts ""
  case option
  when "n"
    newmap
  when "l"
    loadmap
  when "e"
    edittile
  when "s"
    savemap
  when "q"
    puts "buh bye!"
  when "i"
    newisland
  when "c"
    newlands
  when "z"
    clearmap
  else
    puts "invalid command"
    menu
  end
end

def loadmap
  print "Enter map name: "
  mapfile = STDIN.gets.chomp
  @map = YAML::load( File.open( "#{$root_dir}/maps/#{mapfile}.fmap" ) )
  @map.composite($temp_map_name)
  puts "loaded #{mapfile}"
  menu
end

def savemap
  print "Enter map name: "
  mapfilename = STDIN.gets.chomp
  mapfile = File.new("#{$root_dir}/maps/#{mapfilename}.fmap", "w")
  mapfile.puts @map.to_yaml 
  mapfile.close
  @map.composite("#{mapfilename}")
  puts "saved"
  menu
end

def edittile
  print "x: "
  x = STDIN.gets.chomp.to_i
  print "y: "
  y = STDIN.gets.chomp.to_i
  print "type: "
  type = STDIN.gets.chomp
  case type
  when "w"
    type = "water"
  when "l"
    type = "land"
  end
  @map.set_tile(x,y,type)
  @map.composite($temp_map_name)
  menu
end

def newisland
  puts "map is #{@map.tiles_across} tiles across"
  print "x: "
  x = STDIN.gets.chomp.to_i
  print "y: "
  y = STDIN.gets.chomp.to_i
  print "size: "
  size = STDIN.gets.chomp.to_i
  @map.generate_island(x,y,size)
  @map.composite($temp_map_name)
  puts "island generated"
  menu
end

def newlands
  print "Enter percentage of map to be land: "
  landpercentage = STDIN.gets.chomp
  landpercentage = "0.#{landpercentage}".to_f
  @map.generate_lands(landpercentage)
  @map.composite($temp_map_name)
  puts "land generated"
  menu
end

def clearmap
  @map = Map.new
  @map.create(@map_pixels_across,@tile_pixels_across,@map_base_tile,@tileset,@map_edge_space)
  @map.composite($temp_map_name)
  puts "cleared map"
  menu
end

def newmap  
  @map = Map.new
  print "Enter how many pixels across the map should be: [ Enter for default of #{$map_pixels_across} ] "
  @map_pixels_across = STDIN.gets.chomp.to_i
  if @map_pixels_across < 1
    @map_pixels_across = $map_pixels_across
  end
  print "Enter how many pixels across each tile should be: [ Enter for default of #{$tile_pixels_across} ] "
  @tile_pixels_across = STDIN.gets.chomp.to_i
  if @tile_pixels_across < 1
    @tile_pixels_across = $tile_pixels_across
  end
  print "Enter name of the tileset: [ Enter for default of #{$tileset} ] "
  @tileset = STDIN.gets.chomp
  if @tileset == ""
    @tileset = $tileset
  end
  print "Enter name of base tile: [ Enter for default of #{$map_base_tile} ] "
  @map_base_tile = STDIN.gets.chomp
  if @map_base_tile == ""
    @map_base_tile = $map_base_tile
  end
  print "Enter amount of base tile to border the edge of the map [ Enter for default of #{$map_edge_space} ] "
  @map_edge_space = STDIN.gets.chomp.to_i
  if @map_edge_space < 1
    @map_edge_space = $map_edge_space
  end
  @map.create(@map_pixels_across,@tile_pixels_across,@map_base_tile,@tileset,@map_edge_space)
  @map.composite($temp_map_name)
  puts "created new map"
  menu
end

end


Maptool.new