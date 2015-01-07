#!/usr/bin/env jruby

require 'java'
require 'find'

COMMAND_NAME = 'processing.rb'
WATCH_INTERVAL = 0.1

if ARGV.size < 1
  puts "Usage: #{COMMAND_NAME} [sketchfile]"
  exit
end

SKETCH_FILE = ARGV[0]
unless File.exist?(SKETCH_FILE) && FileTest.file?(SKETCH_FILE)
  puts "#{COMMAND_NAME}: Sketch file not found -- '#{SKETCH_FILE}'"
  exit
end

SKETCH_TITLE = File.basename(SKETCH_FILE)
SKETCH_DIR = File.dirname(SKETCH_FILE)

PROCESSING_LIBRARY_DIRS = [
  File.join(SKETCH_DIR, 'libraries'),
  File.expand_path('Documents/Processing/libraries', '~'),
  '/Applications/Processing.app/Contents/Java/modes/java/libraries',
  '%PROGRAMFILES%/processing-*/modes/java/libraries',
  '%PROGRAMFILES(X86)%/processing-*/modes/java/libraries',
  '/Applications/Processing.app/Contents/Java',
  '%PROGRAMFILES%/processing-*',
  '%PROGRAMFILES(X86)%/processing-*',
  'C:/processing-*',
  ENV['PROCESSING_ROOT']
].collect { |dir| dir && File.directory?(dir) ? Dir.glob(dir) : [] }.flatten

def load_library(name)
  PROCESSING_LIBRARY_DIRS.each do |dir|
    dir = File.join(dir, name, 'library')
    return true if load_jar_files(dir)
  end
  puts "#{COMMAND_NAME}: Library not found -- '#{name}'"
  false
end

def load_jar_files(dir)
  is_success = false
  if File.directory?(dir)
    Dir.glob(File.join(dir, '*.jar')).each do |jar|
      require jar
      is_success = true
      puts "#{COMMAND_NAME}: Jar file loaded -- #{File.basename(jar)}"
    end
    return true if is_success
  end
  false
end

exit unless load_library 'core'

%w(
  FontTexture FrameBuffer LinePath LineStroker PGL PGraphics2D
  PGraphics3D PGraphicsOpenGL PShader PShapeOpenGL Texture
).each do |class_|
  java_import "processing.opengl.#{class_}"
end

INITIAL_MODULES = $LOADED_FEATURES.dup

# Base class for Processing sketch
class SketchBase < Java::ProcessingCore::PApplet
  %w(
    displayHeight displayWidth frameCount keyCode
    mouseButton mouseX mouseY pmouseX pmouseY
  ).each do |method|
    snake_case_method = method.gsub(/([A-Z])/, '_\1').downcase
    alias_method snake_case_method, method
  end

  def run_sketch
    SketchBase.run_sketch([SKETCH_TITLE], self)
  end

  def dispose
    frame.dispose
    super
  end
end

def _eval_sketch_code
  sketch_code = File.read(SKETCH_FILE)
  sketch_code = "class Sketch < SketchBase; #{sketch_code}; end"
  Object.class_eval(sketch_code, SKETCH_FILE)
  sketch = Sketch.new
  sketch.run_sketch
  sketch
end

def _create_and_run_sketch
  thread = Thread.new do
    sketch = nil
    begin
      sketch = _eval_sketch_code
    rescue Exception => e # rubocop:disable Lint/RescueException
      puts e
    end
    sketch
  end
  thread.value
end

def _watch_file_changes
  execute_time = Time.now
  loop do
    sleep(WATCH_INTERVAL)
    Find.find(SKETCH_DIR) do |file|
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
  java.lang.System.gc
end

loop do
  sketch = _create_and_run_sketch
  _watch_file_changes
  _restore_execution_environment(sketch)
end
