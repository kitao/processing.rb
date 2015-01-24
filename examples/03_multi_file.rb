require_relative 'modules/sub'

# multi file example
class Sketch < Processing::SketchBase
  def setup
    size(400, 300, OPENGL)
  end

  def draw
  end
end

Processing.start(Sketch.new, topmost: true, pos: [600, 400])
