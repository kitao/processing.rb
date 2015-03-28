require 'processing'

require_relative 'modules/textured_cube'

Processing.load_library 'video'
Processing.import_package 'processing.video', 'Video'

# An example of using Processing-buildin libraries
class Sketch < Processing::SketchBase
  include TexturedCube

  MOVIE1 = Processing.complete_path('data/cat.mov')
  MOVIE2 = Processing.complete_path('data/dog.mov')

  def setup
    size(800, 400, OPENGL)
    no_stroke

    @mov1 = Video::Movie.new(self, MOVIE1)
    @mov1.loop

    @mov2 = Video::Movie.new(self, MOVIE2)
    @mov2.loop
  end

  def draw
    background(80, 100, 180)
    lights

    @mov1.read if @mov1.available
    @mov2.read if @mov2.available

    push_matrix

    translate(220, 200, -50)
    rotate_x(frame_count / 200.0)
    rotate_y(frame_count / 150.0)
    textured_cube(220, @mov1, 0.22, 0, 0.78, 1)

    pop_matrix

    translate(580, 200, -50)
    rotate_x(frame_count / 200.0)
    rotate_y(frame_count / 150.0)
    textured_cube(220, @mov2, 0.22, 0, 0.78, 1)
  end
end

Processing.start(Sketch.new, topmost: true, pos: [300, 300])
