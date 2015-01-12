require_relative 'sub'

Processing.load_library 'video'
java_import 'processing.video.Capture'

#
class Sketch < Processing::SketchBase
  def setup
    size(400, 300, OPENGL)

    cameras = Capture.list
    puts cameras[0]
    @camera = Capture.new(self, cameras[0])
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

    draw2

    puts 'key pressed' if key_pressed?
    puts "mouse pressed: #{mouse_x}" if mouse_pressed?
  end

  def key_pressed
    puts 'key_pressed callback'
    return unless key == 'r'
    puts 'reload'
    Processing.reload_sketch
  end
end

Processing.run_sketch(Sketch.new)