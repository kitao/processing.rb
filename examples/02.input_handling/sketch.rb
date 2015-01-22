# input handling example
class Sketch < Processing::SketchBase
  CIRCLE_NUM = 40
  MIN_RADIUS, MAX_RADIUS = 40, 80
  MIN_ALPHA, MAX_ALPHA = 64, 255

  def setup
    @pos = []

    size(600, 400)
    background(128)

    fill(255)
    stroke_weight(4)

    text_size(30)
    text_align(CENTER)
    text("Press 'r' to Reload", width / 2, height - 15)
  end

  def draw
    if @pos.empty?
      return if mouse_x == 0 && mouse_y == 0

      # initialize the position array when the mouse moves
      (0...CIRCLE_NUM).each do
        @pos << Processing::PVector.new(mouse_x, mouse_y)
      end
    end

    @pos[frame_count % CIRCLE_NUM].set(mouse_x, mouse_y)

    (0...CIRCLE_NUM).each do |i|
      pos = @pos[(frame_count + i + 1) % CIRCLE_NUM]
      rad = map(i, 0, CIRCLE_NUM, MAX_RADIUS, MIN_RADIUS)
      alpha = map(i, 0, CIRCLE_NUM, MIN_ALPHA, MAX_ALPHA)

      stroke(0, 128, 255, alpha)
      ellipse(pos.x, pos.y, rad, rad)
    end
  end

  def key_pressed
    Processing.reload if key == 'r'
  end
end

Processing.start(Sketch.new, topmost: true, pos: [600, 400])
