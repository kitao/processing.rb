require_relative 'modules/sub'

# example to use mutiple modules
class Sketch < Processing::SketchBase
  def setup
    size(400, 300, OPENGL)
  end

  def draw
  end

  def key_pressed
    return unless key == 'r'
    Processing.reload
  end
end

Processing.start(Sketch.new, topmost: true, pos: [600, 400])
