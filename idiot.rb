#!/usr/bin/env ruby 

# dragon
# 2006 drr
# all rights negated

class Idiot
  
  attr_reader :image, :x, :y, :name
  
  def initialize(location)
    @image = Magick::Image.read("#{$root_dir}/peices/dragon.png").first
    @x = location.split(",").first.to_i
    @y = location.split(",").last.to_i
    @name = "idiot"
  end
  
  def turn(map)
    @map = map
    location = move_spot("land")
    @x = location.split(",").first.to_i
    @y = location.split(",").last.to_i
    return map
  end
  
  def move_spot(type)
    x = @x
    y = @y
    tile = "crap"
    until(tile == type)
     x = @x
     y = @y
     x = x + rand(2)
     y = y + rand(2)
     x = x - rand(2)
     y = y - rand(2)
     
     if @map.valid_spot(x,y)
      tile = @map.tile(x,y)
     end
    end  
    @x = x
    @y = y
    return "#{x},#{y}"
  end
  
  def random_spot(type)
    x = 0
    y = 0
    tile = @map.tile(x,y)
    until(tile == type)
     x = rand(@map.tiles_across-1)
     y = rand(@map.tiles_across-1)
     tile = @map.tile(x,y)
    end  
    return "#{x},#{y}"
  end

end
