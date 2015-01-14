# simple sketch example
class Sketch < Processing::SketchBase
  RADIUS = 8
  SPEED = 3

  def setup
    size(480, 240)
    background(0)
    no_stroke

    @x = @y = RADIUS
    @vx = @vy = SPEED
  end

  def update
    @vx *= -1 if @x < RADIUS || @x > width - RADIUS
    @vy *= -1 if @y < RADIUS || @y > height - RADIUS

    @x += @vx
    @y += @vy
  end

  def draw
    update

    fill(0, 8)
    rect(0, 0, width, height)

    fill(255, 204, 0)
    ellipse(@x, @y, RADIUS * 2, RADIUS * 2)
  end
end

Processing.run_sketch(Sketch.new)
