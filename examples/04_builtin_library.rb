Processing.load_library 'video'
Processing.import_package 'processing.video', 'Video'

# example of using Processing-buildin libraries
class Sketch < Processing::SketchBase
  def setup
    size(400, 300)

    @mov = Video::Movie.new(self, Processing.sketch_path('assets/transit.mov'))
    @mov.loop
  end

  def draw
    @mov.read if @mov.available

    image(@mov, 0, 0)
  end
end

Processing.start(Sketch.new, topmost: true, pos: [300, 300])
