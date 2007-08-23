class Ship < Idiot

  def initialize(location)
    @image = Magick::Image.read("#{$root_dir}/peices/ship.png").first
    @x = location.split(",").first.to_i
    @y = location.split(",").last.to_i
    @name = "ship"
  end
  
  def turn(map)
    @map = map
    location = move_spot("water")
    @x = location.split(",").first.to_i
    @y = location.split(",").last.to_i
    return map
  end
  
end
