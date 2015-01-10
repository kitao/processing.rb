require_relative 'sub'

def setup
  size(400, 300, OPENGL)
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
  puts 'mouse pressed' if mouse_pressed?
end

def key_pressed
  reload_sketch if key == 'r'
end
