require 'processing'

require_relative 'modules/moving_box'

# An example of splitting the sketch into multiple files
class Sketch < Processing::SketchBase
  CUBE_NUM = 200
  
  def settings
    size(640, 360, OPENGL)
  end

  def setup
    background(0)
    no_stroke

    @angle = 0
    @boxes = []

    (0...CUBE_NUM).each do |i|
      @boxes[i] = MovingBox.new(
        self,
        random(-280, 280), random(-280, 280), random(-280, 280),
        random(5, 25), random(5, 25), random(5, 25)
      )
    end
  end

  def draw
    background(192, 97, 70)
    fill(200)

    point_light(128, 169, 125, -65, 60, -150)
    point_light(69, 117, 115, 65, -60, 100)
    ambient_light(80, 58, 71)

    translate(width / 2, height / 2, -200 + mouse_x * 0.65)
    rotate_y(radians(@angle))
    rotate_x(radians(@angle))

    @boxes.each(&:draw)

    @angle += 0.2
  end
end

Processing.start(Sketch.new, topmost: true, pos: [300, 300])
