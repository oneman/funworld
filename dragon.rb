class Dragon < Idiot
  
  def initialize(location)
    @image = Magick::Image.read("#{$root_dir}/peices/dragon.png").first
    @x = location.split(",").first.to_i
    @y = location.split(",").last.to_i
    @name = "dragon"
  end
  
end