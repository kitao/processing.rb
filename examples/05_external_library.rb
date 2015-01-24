# example of using external libraries for Processing
class Sketch < Processing::SketchBase
  def setup
    size(480, 240)
  end

  def draw
  end
end

Processing.start(Sketch.new, topmost: true, pos: [300, 300])
