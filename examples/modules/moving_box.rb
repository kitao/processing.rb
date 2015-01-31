# Draws a moving box of the speficied size
class MovingBox
  def initialize(sketch, x, y, z, w, h, d)
    @sketch = sketch
    @x, @y, @z = x, y, z
    @w, @h, @d = w, h, d
  end

  def draw
    x, y, z = @x, @y, @z
    w, h, d = @w, @h, @d

    @sketch.instance_eval do
      push_matrix

      x += sin(frame_count / 10.0 + y) * 10.0
      translate(x, y, z)
      box(w, h, d)

      pop_matrix
    end
  end
end
