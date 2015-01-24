# draws a cube of the speficied size
class Cube
  def initialize(w, h, d, sx, sy, sz)
    @w, @h, @d = w, h, d
    @sx, @sy, @sz = sx, sy, sz
  end

  def draw_cube(sketch)
    w, h, d = @w, @h, @d
    sx, sy, sz = @sx, @sy, @sz

    sketch.instance_eval do
      begin_shape(self.class::QUADS)

      # front face
      vertex(-w / 2 + sx, -h / 2 + sy, -d / 2 + sz)
      vertex(w + sx, -h / 2 + sy, -d / 2 + sz)
      vertex(w + sx, h + sy, -d / 2 + sz)
      vertex(-w / 2 + sx, h + sy, -d / 2 + sz)

      # back face
      vertex(-w / 2 + sx, -h / 2 + sy, d + sz)
      vertex(w + sx, -h / 2 + sy, d + sz)
      vertex(w + sx, h + sy, d + sz)
      vertex(-w / 2 + sx, h + sy, d + sz)

      # left face
      vertex(-w / 2 + sx, -h / 2 + sy, -d / 2 + sz)
      vertex(-w / 2 + sx, -h / 2 + sy, d + sz)
      vertex(-w / 2 + sx, h + sy, d + sz)
      vertex(-w / 2 + sx, h + sy, -d / 2 + sz)

      # right face
      vertex(w + sx, -h / 2 + sy, -d / 2 + sz)
      vertex(w + sx, -h / 2 + sy, d + sz)
      vertex(w + sx, h + sy, d + sz)
      vertex(w + sx, h + sy, -d / 2 + sz)

      # top face
      vertex(-w / 2 + sx, -h / 2 + sy, -d / 2 + sz)
      vertex(w + sx, -h / 2 + sy, -d / 2 + sz)
      vertex(w + sx, -h / 2 + sy, d + sz)
      vertex(-w / 2 + sx, -h / 2 + sy, d + sz)

      # bottom face
      vertex(-w / 2 + sx, h + sy, -d / 2 + sz)
      vertex(w + sx, h + sy, -d / 2 + sz)
      vertex(w + sx, h + sy, d + sz)
      vertex(-w / 2 + sx, h + sy, d + sz)

      end_shape

      # add some rotation to each box for pizazz
      rotate_y(radians(1))
      rotate_x(radians(1))
      rotate_z(radians(1))
    end
  end
end
