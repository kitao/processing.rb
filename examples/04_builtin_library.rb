Processing.load_library 'video'
Processing.import_package 'processing.video'

# example of using Processing-buildin libraries
class Sketch < Processing::SketchBase
  def setup
    size(400, 300, OPENGL)

    cameras = Processing::Capture.list
    puts cameras[0]
    @camera = Processing::Capture.new(self, cameras[0])
    @camera.start
  end

  def draw
    unless frame.is_always_on_top
      frame.set_always_on_top(true)
      frame.set_location(800, 500)
    end

    background(0, 128, 0)

    @camera.read if @camera.available
    image(@camera, 0, 0)

    fill(255, 0, 0)
    rect(100, 100, 100, 100)
  end

  def key_pressed
    return unless key == 'r'
    Processing.reload
  end
end

Processing.start(Sketch.new, topmost: true, pos: [600, 400])
