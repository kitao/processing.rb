# simple sketch example
class Sketch < Processing::SketchBase
  RADIUS = 8
  SPEED = 3

  def setup
    size(480, 240)

    @x = @y = RADIUS
    @vx = @vy = SPEED

    background(0)
    no_stroke
  end

  def draw
    fill(0, 8)
    rect(0, 0, width, height)

    @x += @vx
    @y += @vy

    @vx *= -1 if @x <= RADIUS || @x >= width - RADIUS
    @vy *= -1 if @y <= RADIUS || @y >= height - RADIUS

    fill(255, 204, 0)
    ellipse(@x, @y, RADIUS * 2, RADIUS * 2)
  end
end

Processing.start(Sketch.new)
