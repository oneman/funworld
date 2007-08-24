#!/usr/bin/env ruby 

# 'funworld' game
# 2006 drr
# all rights negated

require 'gosu'

require 'conf'
require 'map'

require 'idiot'
require 'dragon'
require 'ship'


class Game < Gosu::Window

  
  def initialize

    print "Enter level name: "
    mapfile = STDIN.gets.chomp

    #@fork = fork do
    # while 1 == 1
    #  turn
    #  sleep 3
    # end
    # puts "fuck turn thread died"
    #end



    super(700, 700, false, 20)
    @map = YAML::load( File.open( "#{$root_dir}/maps/#{mapfile}.fmap" ) )
    @peices = []

      @peices.push Dragon.new(random_spot("land"), self, "overkill")
      @peices.push Dragon.new(random_spot("land"), self, "onemaN")


     @peices.push Ship.new(random_spot("water"), self, "Monster")
     @peices.push Ship.new(random_spot("water"), self, "Swift")
     @peices.push Ship.new(random_spot("water"), self, "Ike")


    self.caption = "funworld woot"
    @background_image = Gosu::Image.new(self, "#{$root_dir}/maps/#{mapfile}.png", true)
   # console
  end

  def draw
      update
  end

  def update
    @background_image.draw(0, 0, 0);

      #do a turn like every second
      @counta ||= 1
      if @counta == 1
    @background_image.draw(0, 0, 0);
         turn
      end
      @counta += 1
      if @counta > (@map.tilesize * 2)
         @counta = 1
     end    
    @peices.each { |peice| @map = peice.draw(@map) }
  end
  
  
  def turn
    @peices.each { |peice| @map = peice.turn(@map, @peices) }
    @peices.each { |peice| puts "#{peice.name} at #{peice.x}, #{peice.y}" }   
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


game = Game.new
game.show
