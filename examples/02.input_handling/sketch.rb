# input handling example
class Sketch < Processing::SketchBase
  CIRCLE_NUM = 40

  def setup
    size(600, 400)

    @pos = []
    (0...CIRCLE_NUM).each { @pos << Processing::PVector.new(0, 0) }

    # no_stroke
  end

  def draw
    background(0, 128, 0)

    @pos[frame_count % CIRCLE_NUM].set(mouse_x, mouse_y)

    (0...CIRCLE_NUM).each do |i|
      pos = @pos[(frame_count + CIRCLE_NUM - i - 1) % CIRCLE_NUM]
      rad = map(i, 0, CIRCLE_NUM, 50, 10)
      # fill(255, CIRCLE_NUM - rad)
      ellipse(pos.x, pos.y, 30 + rad, 30 + rad)
    end
  end

  def key_pressed
    Processing.reload if key == 'r'
  end
end

Processing.start(Sketch.new, topmost: true, pos: [600, 400])
