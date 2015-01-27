require_relative 'modules/cube'

# example of splitting the sketch into multiple files
class Sketch < Processing::SketchBase
  CUBE_NUM = 200

  def setup
    size(640, 360, OPENGL)
    background(0)
    no_stroke

    @angle = 0
    @cubes = []

    (0...CUBE_NUM).each do |i|
      @cubes[i] = Cube.new(
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

    @cubes.each { |cube| cube.draw(self) }

    @angle += 0.2
  end
end

Processing.start(Sketch.new, topmost: true, pos: [800, 300])
