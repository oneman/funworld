#!/usr/bin/env ruby 

# dragon
# 2006 drr
# all rights negated

class Idiot
  
  attr_reader :image, :x, :y, :name
  
  def initialize(location, window, name="idiot")
    #@image = Magick::Image.read("#{$root_dir}/peices/dragon.png").first
    @x = location.split(",").first.to_i
    @y = location.split(",").last.to_i
    @name = "idiot"
    @tiletype = "land"
    @font = Gosu::Font.new(window, Gosu::default_font_name, 20)
  end
  
  def turn(map, peices)
    @map = map
    @old_x = @x
    @old_y = @y
    location = move_spot(@tiletype)
    @x = location.split(",").first.to_i
    @y = location.split(",").last.to_i 
    peices.each { |peice| unless peice == self
  
   if peice.x == @x && peice.y == @y
   # cancel move
   @x = @old_x
   @y = @old_y
   puts "potential collision between #{self.name} and #{peice.name}"
   end

   end }
    @moving = true
    return map
  end

  def draw(map)
    @map = map
    unless @moving
    @image.draw(@x * @map.tilesize, @y * @map.tilesize, 1,1)
    @font.draw(self.name, (@x * @map.tilesize) + 10, (@y * @map.tilesize) + 44, 10, 1.0, 1.0, 0xffffffff)
    else
      @counta ||= 1
      if @counta == 1

         #turn
      end
      @counta += 1

     if @old_x > @x
        if @old_y > @y
             @image.draw(((@old_x * @map.tilesize) - @counta), ((@old_y * @map.tilesize) - @counta), 1,1)
    @font.draw(self.name, ((@old_x * @map.tilesize) - @counta) + 10, ((@old_y * @map.tilesize) - @counta) + 44, 10, 1.0, 1.0, 0xffffffff)
        end
        if @old_y < @y
             @image.draw(((@old_x * @map.tilesize) - @counta), ((@old_y * @map.tilesize) + @counta), 1,1)
    @font.draw(self.name, ((@old_x * @map.tilesize) - @counta) + 10, ((@old_y * @map.tilesize) + @counta) + 44, 10, 1.0, 1.0, 0xffffffff)
        end
     end
     if @old_x < @x
        if @old_y > @y
             @image.draw(((@old_x * @map.tilesize) + @counta), ((@old_y * @map.tilesize) - @counta), 1,1)
    @font.draw(self.name, ((@old_x * @map.tilesize) + @counta) + 10, ((@old_y * @map.tilesize) - @counta) + 44, 10, 1.0, 1.0, 0xffffffff)
        end
        if @old_y < @y
             @image.draw(((@old_x * @map.tilesize) + @counta), ((@old_y * @map.tilesize) + @counta), 1,1)
    @font.draw(self.name, ((@old_x * @map.tilesize) + @counta) + 10, ((@old_y * @map.tilesize) + @counta) + 44, 10, 1.0, 1.0, 0xffffffff)
        end
     end 

     if @old_x == @x
        if @old_y > @y
             @image.draw(((@old_x * @map.tilesize)), ((@old_y * @map.tilesize) - @counta), 1,1)
    @font.draw(self.name, (@x * @map.tilesize) + 10, ((@old_y * @map.tilesize) - @counta) + 44, 10, 1.0, 1.0, 0xffffffff)
        end
        if @old_y < @y
             @image.draw(((@old_x * @map.tilesize)), ((@old_y * @map.tilesize) + @counta), 1,1)
    @font.draw(self.name, (@x * @map.tilesize) + 10, ((@old_y * @map.tilesize) + @counta) + 44, 10, 1.0, 1.0, 0xffffffff)
        end
     end
     if @old_y == @y
        if @old_x > @x
             @image.draw(((@old_x * @map.tilesize) - @counta), ((@old_y * @map.tilesize)), 1,1)
    @font.draw(self.name, ((@old_x * @map.tilesize) - @counta) + 10, ((@old_y * @map.tilesize)) + 44, 10, 1.0, 1.0, 0xffffffff)
        end
        if @old_x < @x
             @image.draw(((@old_x * @map.tilesize) + @counta), ((@old_y * @map.tilesize)), 1,1)
    @font.draw(self.name, ((@old_x * @map.tilesize) + @counta) + 10, ((@old_y * @map.tilesize)) + 44, 10, 1.0, 1.0, 0xffffffff)
        end
     end
     
     if @old_x == @x && @old_y == @y
            @image.draw(@x * @map.tilesize, @y * @map.tilesize, 1,1)
    @font.draw(self.name, (@x * @map.tilesize) + 10, (@y * @map.tilesize) + 44, 10, 1.0, 1.0, 0xffffffff)
     end

     if @counta == @map.tilesize
        @moving = false
        @counta = 1
     end

     

    end
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
