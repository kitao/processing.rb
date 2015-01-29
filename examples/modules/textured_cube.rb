# Draws the cube with the specified texture
module TexturedCube
  def textured_cube(size, pimage, u1, v1, u2, v2)
    w = h = d = size / 2.0

    u1 *= pimage.width.to_f
    v1 *= pimage.height.to_f
    u2 *= pimage.width.to_f
    v2 *= pimage.height.to_f

    begin_shape(Processing::QUADS)

    texture(pimage)

    vertex(-w, -h, d, u1, v1)
    vertex(w, -h, d, u2, v1)
    vertex(w, h, d, u2, v2)
    vertex(-w, h, d, u1, v2)

    vertex(w, -h, -d, u1, v1)
    vertex(-w, -h, -d, u2, v1)
    vertex(-w, h, -d, u2, v2)
    vertex(w, h, -d, u1, v2)

    vertex(-w, h, d, u1, v1)
    vertex(w, h, d, u2, v1)
    vertex(w, h, -d, u2, v2)
    vertex(-w, h, -d, u1, v2)

    vertex(-w, -h, -d, u1, v1)
    vertex(w, -h, -d, u2, v1)
    vertex(w, -h, d, u2, v2)
    vertex(-w, -h, d, u1, v2)

    vertex(w, -h, d, u1, v1)
    vertex(w, -h, -d, u2, v1)
    vertex(w, h, -d, u2, v2)
    vertex(w, h, d, u1, v2)

    vertex(-w, -h, -d, u1, v1)
    vertex(-w, -h, d, u2, v1)
    vertex(-w, h, d, u2, v2)
    vertex(-w, h, -d, u1, v2)

    end_shape
  end
end
