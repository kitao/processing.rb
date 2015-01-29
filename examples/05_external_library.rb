Processing.load_library 'handy'
Processing.import_package 'org.gicentre.handy', 'Handy'

# An example of using external libraries for Processing
class Sketch < Processing::SketchBase
  def setup
    size(480, 240)

    @handy = Handy::HandyRenderer.new(self)
  end

  def draw
    background(234, 215, 182)

    @handy.instance_eval do
      set_roughness(1)

      set_fill_gap(0.5)
      set_fill_weight(0.1)
      rect(50, 30, 80, 50)

      set_fill_gap(3)
      set_fill_weight(2)
      rect(170, 30, 80, 50)

      set_fill_gap(5)
      set_is_alternating(true)
      rect(50, 120, 80, 50)

      set_roughness(3)
      set_fill_weight(1)
      set_is_alternating(false)
      rect(170, 120, 80, 50)
    end
  end
end

Processing.start(Sketch.new, topmost: true, pos: [300, 300])
