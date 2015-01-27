# draws a cube of the speficied size
class Cube
  def initialize(x, y, z, w, h, d)
    @x, @y, @z = x, y, z
    @w, @h, @d = w, h, d
  end

  def draw(sketch)
    x, y, z = @x, @y, @z
    w2, h2, d2 = @w / 2, @h / 2, @d / 2

    sketch.instance_eval do
      push_matrix

      x += sin(frame_count / 10.0 + y) * 10
      translate(x, y, z)

      begin_shape(self.class::QUADS)

      # front face
      vertex(-w2, -h2, -d2)
      vertex(w2, -h2, -d2)
      vertex(w2, h2, -d2)
      vertex(-w2, h2, -d2)

      # front face
      vertex(-w2, -h2, -d2)
      vertex(w2, -h2, -d2)
      vertex(w2, h2, -d2)
      vertex(-w2, h2, -d2)

      # back face
      vertex(-w2, -h2, d2)
      vertex(w2, -h2, d2)
      vertex(w2, h2, d2)
      vertex(-w2, h2, d2)

      # left face
      vertex(-w2, -h2, -d2)
      vertex(-w2, -h2, d2)
      vertex(-w2, h2, d2)
      vertex(-w2, h2, -d2)

      # right face
      vertex(w2, -h2, -d2)
      vertex(w2, -h2, d2)
      vertex(w2, h2, d2)
      vertex(w2, h2, -d2)

      # top face
      vertex(-w2, -h2, -d2)
      vertex(w2, -h2, -d2)
      vertex(w2, -h2, d2)
      vertex(-w2, -h2, d2)

      # bottom face
      vertex(-w2, h2, -d2)
      vertex(w2, h2, -d2)
      vertex(w2, h2, d2)
      vertex(-w2, h2, d2)

      end_shape

      pop_matrix
    end
  end
end
