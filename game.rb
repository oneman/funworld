#!/usr/bin/env ruby 

# 'funworld' game
# 2006 drr
# all rights negated

require 'conf'
require 'map'

require 'idiot'
require 'dragon'
require 'ship'


class Game
  
  def initialize
    print "Enter level name: "
    mapfile = STDIN.gets.chomp
    @map = YAML::load( File.open( "#{$root_dir}/maps/#{mapfile}.fmap" ) )
    @peices = []
    4.times do 
      @peices.push Dragon.new(random_spot("land"))
    end
    2.times do
     @peices.push Ship.new(random_spot("water"))
     @peices.push Ship.new(random_spot("water"))
    end 
    @fork = fork do
     while 1 == 1
      turn
      sleep 3
     end
     puts "fuck turn thread died"
    end
    puts "forked turn thread pid: #{@fork}"
    console
  end
  
  def console
    print "#{$game}> "
    command = STDIN.gets.chomp
    case command
    when "q"
      `kill -9 #{@fork}`
      puts "buh bye"
    when "h"
      puts "i for investigation\nq to quit"
      console
    when "i"
      investigate
      console
    else
      puts "h for help"
      console
    end
  end
  
  def investigate
    @peices.each { |peice| puts "#{peice.name} at #{peice.x}, #{peice.y}" }   
  end
  
  def turn
    @peices.each { |peice| @map = peice.turn(@map) }
    render
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
  
  def render
    @map.composite("game")
    map = Magick::Image.read("#{$root_dir}/maps/game.png").first
    @peices.each { |peice| map.composite!(peice.image, (peice.x * @map.tilesize), (peice.y * @map.tilesize), OverCompositeOp) }
    map.write("#{$root_dir}/public/game.png")  
  end
  
end


game = Game.new