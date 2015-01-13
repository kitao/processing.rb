# simple sketch based on the Sine example in Processing
class Sketch < Processing::SketchBase
  def setup
    size(640, 360)

    @diameter = height - 10
    @angle = 0

    no_stroke
    fill(255, 204, 0)
  end

  def draw
    background(0)

    d1 = 10 + (Math.sin(@angle) * @diameter / 2) + @diameter / 2
    d2 = 10 + (Math.sin(@angle + PI / 2) * @diameter / 2) + @diameter / 2
    d3 = 10 + (Math.sin(@angle + PI) * @diameter / 2) + @diameter / 2

    ellipse(0, height / 2, d1, d1)
    ellipse(width / 2, height / 2, d2, d2)
    ellipse(width, height / 2, d3, d3)

    @angle += 0.02
  end
end

Processing.run_sketch(Sketch.new)
