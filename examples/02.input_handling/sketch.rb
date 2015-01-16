# input handling example
class Sketch < Processing::SketchBase
  def setup
    size(480, 240)
  end

  def draw
    background(0, 128, 0)
  end

  def key_pressed
    Processing.reload if key == 'r'
  end
end

Processing.start(Sketch.new, topmost: true, pos: [600, 400])
