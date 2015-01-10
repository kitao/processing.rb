require_relative 'sub'

load_library 'video'
java_import 'processing.video.Capture'

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

  fill(255, 0, 0)
  rect(100, 100, 100, 100)

  draw2

  puts 'key pressed' if key_pressed?
  puts "mouse pressed: #{mouse_x}" if mouse_pressed?

  @camera.read if @camera.available
  image(@camera, 0, 0)
end

def key_pressed
  reload_sketch if key == 'r'
end
