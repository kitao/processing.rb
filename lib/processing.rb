require 'java'
require 'find'

PROGRAM_NAME = 'processing.rb'
WATCH_INTERVAL = 0.1

PROCESSING_APP_ROOT = ENV['PROCESSING_APP_ROOT']
PROCESSING_SKETCH_ROOT = ENV['PROCESSING_SKETCH_ROOT']

unless PROCESSING_APP_ROOT && PROCESSING_SKETCH_ROOT
  puts <<-EOS
  #{PROGRAM_NAME}: Essential environment variables are not set
  e.g. in the case of Mac, add the following lines to the ~/.bash_profile
  export PROCESSING_APP_ROOT="/Applications/Processing.app/Contents/Java"
  export PROCESSING_SKETCH_ROOT="~/Documents/Processing"
  EOS
  exit
end

if ARGV.size < 1
  puts "Usage: #{PROGRAM_NAME} [sketchfile]"
  exit
end

SKETCH_FILE = ARGV[0]

unless File.exist?(SKETCH_FILE) && FileTest.file?(SKETCH_FILE)
  puts "#{PROGRAM_NAME}: No such file -- '#{SKETCH_FILE}'"
  exit
end

PROCESSING_LIBRARY_PATHS = [
  File.join(File.dirname(SKETCH_FILE), 'libraries'),
  File.join(PROCESSING_SKETCH_ROOT, 'libraries'),
  File.join(PROCESSING_APP_ROOT, 'modes/java/libraries'),
  PROCESSING_APP_ROOT
]

def load_library(name)
  PROCESSING_LIBRARY_PATHS.each do |path|
    path = File.join(path, name, 'library')
    if File.exist?(path) && File.directory?(path)
      load_jar_files(path)
      break
    end
  end
end

def load_jar_files(dir)
  is_dir = File.exist?(dir) && File.directory?(dir)
  Dir.glob(File.join(dir, '*.jar')).each { |jar| require jar } if is_dir
end

load_library 'core'

OPENGL_CLASSES = %w(FontTexture FrameBuffer LinePath LineStroker PGL PGraphics2D
                    PGraphics3D PGraphicsOpenGL PShader PShapeOpenGL Texture)
OPENGL_CLASSES.each { |class_| java_import "processing.opengl.#{class_}" }

INITIAL_MODULES = $LOADED_FEATURES.dup

# Base class for Processing sketch
class SketchBase < Java::ProcessingCore::PApplet
  methods = %w(displayHeight displayWidth frameCount keyCode
               mouseButton mouseX mouseY pmouseX pmouseY)
  methods.each do |method|
    snake_case_method = method.gsub(/([A-Z])/, '_\1').downcase
    alias_method snake_case_method, method
  end

  def run_sketch
    SketchBase.run_sketch([File.basename(SKETCH_FILE)], self)
  end

  def dispose
    frame.dispose
    super
  end
end

def _create_and_run_sketch
  thread = Thread.start do
    sketch_code = File.read(SKETCH_FILE)
    sketch_code = "class Sketch < SketchBase; #{sketch_code}; end"
    Object.class_eval(sketch_code)
    sketch = Sketch.new
    sketch.run_sketch
    sketch
  end
  thread.value
end

def _watch_file_changes
  execute_time = Time.now
  loop do
    sleep(WATCH_INTERVAL)
    Find.find(File.dirname(SKETCH_FILE)) do |file|
      is_ruby = FileTest.file?(file) && File.extname(file) == '.rb'
      return if is_ruby && File.mtime(file) > execute_time
    end
  end
end

def _restore_execution_environment(sketch)
  sketch.dispose if sketch
  Object.class_eval { remove_const(:Sketch) }
  modules = $LOADED_FEATURES - INITIAL_MODULES
  modules.each { |module_| $LOADED_FEATURES.delete(module_) }
end

loop do
  sketch = _create_and_run_sketch
  _watch_file_changes
  _restore_execution_environment(sketch)
end
