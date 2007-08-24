class Ship < Idiot

  def initialize(location, window, name="ship")
    @image = Gosu::Image.new(window, "#{$root_dir}/peices/ship.png", true)
    @x = location.split(",").first.to_i
    @y = location.split(",").last.to_i
    @name = name
    @tiletype = "water"
    @font = Gosu::Font.new(window, Gosu::default_font_name, 20)
  end
  



  
end
