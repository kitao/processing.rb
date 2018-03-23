require 'processing'

Processing.load_library 'handy'
Processing.import_package 'org.gicentre.handy', 'Handy'

BALL_NUM = 6
BALL_COLORS = [[255, 0, 0], [255, 255, 0], [64, 64, 255]]

# An example of using external libraries for Processing
class Sketch < Processing::SketchBase
  attr_reader :handy

  def settings
    size(400, 400)
  end
  
  def setup
    @handy = Handy::HandyRenderer.new(self)

    @balls = []
    (0...BALL_NUM).each { |i| @balls << Ball.new(self, i) }
  end

  def draw
    background(234, 215, 182)

    fill(0, 255, 0)
    @handy.instance_eval do
      rect(20, 20, 360, 20)
      rect(20, 360, 360, 20)
      rect(20, 40, 20, 320)
      rect(360, 40, 20, 320)
    end

    @balls.each(&:draw)
  end

  def key_pressed
    Processing.reload if key == 'r'
  end
end

# Bouncing ball
class Ball
  def initialize(sketch, id)
    @sketch = sketch

    @x, @y = @sketch.random(100, 300), @sketch.random(100, 300)
    @vx, @vy = @sketch.random(-6, 6), @sketch.random(-6, 6)

    @size = @sketch.random(60, 100)
    @radius = @size / 2.0

    @color = BALL_COLORS[id % BALL_COLORS.size]

    @min_x = @min_y = 40 + @radius
    @max_x = @max_y = 360 - @radius
  end

  def draw
    @x += @vx
    @y += @vy

    @vy += 0.1

    if @x < @min_x
      @x = @min_x
      @vx = -@vx
    end

    if @x > @max_x
      @x = @max_x
      @vx = -@vx
    end

    if @y < @min_y
      @y = @min_y
      @vy = -@vy
    end

    if @y > @max_y
      @y = @max_y
      @vy *= -0.99
    end

    @sketch.fill(*@color)
    @sketch.handy.ellipse(@x, @y, @size, @size)
  end
end

Processing.start(Sketch.new, topmost: true, pos: [300, 300])
