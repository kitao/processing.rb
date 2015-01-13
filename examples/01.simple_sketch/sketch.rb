# simple sketch example
class Sketch < Processing::SketchBase
  BOX_WIDTH = 100
  BOX_HEIGHT = 50

  def setup
    size(400, 300)

    @box_x, @box_y = 0, 0
    @box_vx, @box_vy = 2, 2
  end

  def draw
    background(0)

    fill(255)
    rect(@box_x, @box_y, BOX_WIDTH, BOX_HEIGHT)

    @box_x += @box_vx
    @box_y += @box_vy

    @box_vx *= -1 if @box_x <= 0 || @box_x + BOX_WIDTH >= width
    @box_vy *= -1 if @box_y <= 0 || @box_y + BOX_HEIGHT >= height
  end
end

Processing.run_sketch(Sketch.new)
