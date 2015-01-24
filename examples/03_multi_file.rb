require_relative 'modules/cube'

# example of splitting the sketch into multiple files
class Sketch < Processing::SketchBase
  CUBE_NUM = 500

  def setup
    size(640, 360, OPENGL)
    background(0)
    no_stroke

    @angle = 0
    @cubes = []

    (0...CUBE_NUM).each do |i|
      @cubes[i] = Cube.new(
        random(-10, 10), random(-10, 10),
        random(-10, 10), random(-140, 140),
        random(-140, 140), random(-140, 140)
      )
    end
  end

  def draw
    background(0)
    fill(200)

    point_light(51, 102, 255, 65, 60, 100)
    point_light(200, 40, 60, -65, -60, -150)
    ambient_light(70, 70, 10)

    translate(width / 2, height / 2, -200 + mouse_x * 0.65)
    rotate_y(radians(@angle))
    rotate_x(radians(@angle))

    @cubes.each { |cube| cube.draw(self) }

    @angle += 0.2
  end
end

Processing.start(Sketch.new, topmost: true, pos: [300, 300])
