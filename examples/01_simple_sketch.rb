require 'processing'

# An example of the basic sketch structure
class Sketch < Processing::SketchBase
  LINE_RADIUS = 8
  LINE_SPEED = 3

  def setup
    size(480, 240)
    background(96)
    no_stroke

    @x = @y = LINE_RADIUS
    @vx = @vy = LINE_SPEED
  end

  def draw
    fill(96, 8)
    rect(0, 0, width, height)

    @x += @vx
    @y += @vy

    @vx *= -1 if @x <= LINE_RADIUS || @x >= width - LINE_RADIUS
    @vy *= -1 if @y <= LINE_RADIUS || @y >= height - LINE_RADIUS

    fill(255, 204, 0)
    ellipse(@x, @y, LINE_RADIUS * 2, LINE_RADIUS * 2)
  end
end

Processing.start(Sketch.new)
