# Draws a moving box of the speficied size
class MovingBox
  def initialize(x, y, z, w, h, d)
    @x, @y, @z = x, y, z
    @w, @h, @d = w, h, d
  end

  def draw(sketch)
    x, y, z = @x, @y, @z
    w, h, d = @w, @h, @d

    sketch.instance_eval do
      sketch.push_matrix

      x += sketch.sin(frame_count / 10.0 + y) * 10.0
      sketch.translate(x, y, z)
      sketch.box(w, h, d)

      sketch.pop_matrix
    end
  end
end
