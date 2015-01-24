# example of the basic sketch structure
class Sketch < Processing::SketchBase
  LINE_RADIUS = 8
  LINE_SPEED = 3

  def setup
    @x = @y = LINE_RADIUS
    @vx = @vy = LINE_SPEED

    size(480, 240)
    background(0)
    no_stroke
  end

  def draw
    @x += @vx
    @y += @vy

    @vx *= -1 if @x <= LINE_RADIUS || @x >= width - LINE_RADIUS
    @vy *= -1 if @y <= LINE_RADIUS || @y >= height - LINE_RADIUS

    fill(0, 8)
    rect(0, 0, width, height)

    fill(255, 204, 0)
    ellipse(@x, @y, LINE_RADIUS * 2, LINE_RADIUS * 2)
  end
end

Processing.start(Sketch.new)
