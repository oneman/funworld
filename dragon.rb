class Dragon < Idiot
  
  def initialize(location, window, name="dragon")
    @image = Gosu::Image.new(window, "#{$root_dir}/peices/dragon.png", true)
    #@image = Magick::Image.read("#{$root_dir}/peices/dragon.png").first
    @x = location.split(",").first.to_i
    @y = location.split(",").last.to_i
    @name = name
    @tiletype = "land"
    @font = Gosu::Font.new(window, Gosu::default_font_name, 20)
  end
  
end
