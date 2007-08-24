#!/usr/bin/env ruby 

# map generator
# 2006 drr
# all rights negated

require 'rubygems'
require 'yaml' 
require 'RMagick'
include Magick

class Map

attr_reader :tiles_across, :tilesize

def create(mapsize, tilesize, base, tileset, edgespace)
 @tilesize = tilesize
 @mapsize = mapsize
 @tileset = tileset
 @map_edge_space = edgespace
 @tiles_across = (mapsize/tilesize)
 @map = []
 @tiles_across.times do
  tiles = [] 
  @tiles_across.times do
    tiles.push Tile.new(base)
   end
  @map.push tiles
 end
end

def set_tile(x,y,type)
  @map[y][x].name = type
end

def tile(x,y)
    @map[y][x].name
end

def generate_lands(percentage)
  landmass = ((@tiles_across*@tiles_across)*percentage).to_i
  islands = 1
  puts "Landmass is #{landmass} tiles."
  while landmass > 1
    size = rand(landmass)
    x = -1
    y = -1
    until valid_land_spot(x,y)
      x = rand(@tiles_across)
      y = rand(@tiles_across)
    end 
    generate_island(x,y,size)
    puts "island #{islands} is #{size} tiles."
    landmass = landmass-size
    islands += 1
  end
  puts "#{islands-1} islands were generated (some may have merged)"
end

def valid_land_spot(x,y)
  
  bottomlimit = -1 + @map_edge_space
  toplimit = @map_edge_space
  
  if x > bottomlimit and x < (@tiles_across - toplimit) and y > bottomlimit and y < (@tiles_across - toplimit)
    return true
  else
    return false
  end
end

def valid_spot(x,y)
  if x > -1 and x < @tiles_across and y > -1 and y < @tiles_across
    return true
  else
    return false
  end
end

def generate_island(x,y,size)
  tiles_generated = 0
  while(tiles_generated < size)
    if (@map[y][x].name != "land")
     @map[y][x].name = "land"
     tiles_generated += 1
    end
    moveamount = 1
    movegood = false
    while movegood == false
    direction = rand(4)
    case direction
      when 0
        if valid_land_spot(x+moveamount,y)
           x = x+moveamount
           movegood = true 
        end
      when 1
        if valid_land_spot(x-moveamount,y)
          x = x-moveamount 
          movegood = true
        end
      when 2
        if valid_land_spot(x,y+moveamount)
          y = y+moveamount 
          movegood = true 
        end
      when 3
        if valid_land_spot(x,y-moveamount)
          y = y-moveamount 
          movegood = true 
        end
      end
    moveamount = moveamount+1  
    end
  end
end

def composite(filename)
  mapimage = Magick::Image.new(@mapsize, @mapsize)
  
  maptiles = Hash.new
  maptiles['land'] = Magick::Image.read("#{$root_dir}/tilesets/#{@tileset}/land.png").first
  maptiles['water'] = Magick::Image.read("#{$root_dir}/tilesets/#{@tileset}/water.png").first
  
  westcoast = Magick::Image.read("#{$root_dir}/tilesets/#{@tileset}/coast.png").first
  eastcoast = Magick::Image.read("#{$root_dir}/tilesets/#{@tileset}/coast.png").first.flop
  northcoast = Magick::Image.read("#{$root_dir}/tilesets/#{@tileset}/coast2.png").first
  southcoast = Magick::Image.read("#{$root_dir}/tilesets/#{@tileset}/coast2.png").first.flip
  coast_corner = Magick::Image.read("#{$root_dir}/tilesets/#{@tileset}/coast_corner.png").first.flip
  coast_corner2 = Magick::Image.read("#{$root_dir}/tilesets/#{@tileset}/coast_corner2.png").first
  
  
  #composite map
  y = 0
  pixely = 0
  for row in @map
    x = 0
    pixelx = 0
    for tile in row
      mapimage.composite!(maptiles["#{tile.name}"], pixelx, pixely, OverCompositeOp)
      x += 1
      pixelx = pixelx + @tilesize
    end
    y += 1
    pixely = pixely + @tilesize
  end 
  
  
  # same loop. composite coasts
  y = 0
  pixely = 0
  for row in @map
    x = 0
    pixelx = 0
    for tile in row
  case tile.name
    when "land"
    #puts tile.name
    #puts "tile #{x},#{y} is land"
    if valid_spot(y,x+1)
      if (@map[y][x+1].name == "water")
        mapimage.composite!(eastcoast, pixelx+40, pixely, OverCompositeOp)
        #puts "drawing eastcost on #{x},#{y} becase #{x+1},#{y} is water"
      end
    end
    if valid_spot(y,x-1)
      if (@map[y][x-1].name == "water")
        mapimage.composite!(westcoast, pixelx, pixely, OverCompositeOp)
        #puts "drawing westcost on #{x},#{y} becase #{x+1},#{y} is water"
      end
    end
    if valid_spot(y-1,x)
      if (@map[y-1][x].name == "water")
        mapimage.composite!(northcoast, pixelx, pixely, OverCompositeOp)
        #puts "drawing northcost on #{x},#{y} becase #{x+1},#{y} is water"
      end
    end
    if valid_spot(y+1,x)
      if (@map[y+1][x].name == "water")
        mapimage.composite!(southcoast, pixelx, pixely+40, OverCompositeOp)
        #puts "drawing southcost on #{x},#{y} becase #{x+1},#{y} is water"
      end
    end
    
    if valid_spot(y+1,x+1)
      if ((@map[y+1][x+1].name == "water") and (@map[y][x+1].name == "water") and (@map[y+1][x].name == "water"))
        mapimage.composite!(coast_corner2.flip.flop, pixelx+40, pixely+40, OverCompositeOp)
      end
    end
    if valid_spot(y-1,x-1)
        if ((@map[y-1][x-1].name == "water") and (@map[y][x-1].name == "water") and (@map[y-1][x].name == "water"))
          mapimage.composite!(coast_corner2, pixelx, pixely, OverCompositeOp)
      end
    end
    if valid_spot(y-1,x+1)
      if ((@map[y-1][x+1].name == "water") and (@map[y-1][x].name == "water") and (@map[y][x+1].name == "water"))
        mapimage.composite!(coast_corner2.flop, pixelx+40, pixely, OverCompositeOp)
      end
    end
    if valid_spot(y+1,x-1)
      if ((@map[y+1][x-1].name == "water") and (@map[y][x-1].name == "water") and (@map[y+1][x].name == "water"))
        mapimage.composite!(coast_corner2.flip, pixelx, pixely+40, OverCompositeOp)
      end
    end
    
  when "water"
    if valid_spot(y+1,x+1)
      if ((@map[y+1][x+1].name == "land") and (@map[y][x+1].name == "land") and (@map[y+1][x].name == "land"))
        mapimage.composite!(coast_corner.flop, pixelx+50, pixely+50, OverCompositeOp)
      end
    end
    if valid_spot(y-1,x-1)
        if ((@map[y-1][x-1].name == "land") and (@map[y][x-1].name == "land") and (@map[y-1][x].name == "land"))
          mapimage.composite!(coast_corner.flip, pixelx-10, pixely-10, OverCompositeOp)
      end
    end
    if valid_spot(y-1,x+1)
      if ((@map[y-1][x+1].name == "land") and (@map[y-1][x].name == "land") and (@map[y][x+1].name == "land"))
        mapimage.composite!(coast_corner.flop.flip, pixelx+50, pixely-10, OverCompositeOp)
      end
    end
    if valid_spot(y+1,x-1)
      if ((@map[y+1][x-1].name == "land") and (@map[y][x-1].name == "land") and (@map[y+1][x].name == "land"))
        mapimage.composite!(coast_corner, pixelx-10, pixely+50, OverCompositeOp)
      end
    end
  else
    puts "huh"
  end
    x += 1
    pixelx = pixelx + @tilesize
  end
  y += 1
  pixely = pixely + @tilesize
end
  
  
  mapimage.write("#{$root_dir}/maps/#{filename}.png")  
end

end

class Tile
 
  attr_accessor :name
  
  def initialize(name)
    @name = name
  end
  
end
