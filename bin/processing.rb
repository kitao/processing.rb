#!/usr/bin/env jruby

exec("jruby #{__FILE__} #{ARGV.join(' ')}") if RUBY_PLATFORM != 'java'

require 'java'
require 'find'

COMMAND_NAME = File.basename(__FILE__)
WATCH_INTERVAL = 0.1

if ARGV.size < 1
  puts "Usage: #{COMMAND_NAME} [sketchfile]"
  exit
end

SKETCH_FILE = ARGV[0]

unless FileTest.file?(SKETCH_FILE)
  puts "#{COMMAND_NAME}: Sketch file not found -- '#{SKETCH_FILE}'"
  exit
end

SKETCH_TITLE = File.basename(SKETCH_FILE)
SKETCH_DIR = File.dirname(SKETCH_FILE)

PROCESSING_ROOT = ENV['PROCESSING_ROOT'] || '/dummy'
PROGRAMFILES = ENV['PROGRAMFILES'] || '/dummy'
PROGRAMFILES_X86 = ENV['PROGRAMFILES(X86)'] || '/dummy'

PROCESSING_LIBRARY_DIRS = [
  File.join(SKETCH_DIR, 'libraries'),
  File.expand_path('Documents/Processing/libraries', '~'),

  PROCESSING_ROOT,
  File.join(PROCESSING_ROOT, 'modes/java/libraries'),

  '/Applications/Processing.app/Contents/Java',
  '/Applications/Processing.app/Contents/Java/modes/java/libraries',

  File.join(PROGRAMFILES, 'processing-*'),
  File.join(PROGRAMFILES, 'processing-*/modes/java/libraries'),

  File.join(PROGRAMFILES_X86, 'processing-*'),
  File.join(PROGRAMFILES_X86, 'processing-*/modes/java/libraries'),

  'C:/processing-*',
  'C:/processing-*/modes/java/libraries'
].flat_map { |dir| Dir.glob(dir) }

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
java_import 'processing.core.PApplet'

%w(FontTexture FrameBuffer LinePath LineStroker PGL PGraphics2D
   PGraphics3D PGraphicsOpenGL PShader PShapeOpenGL Texture
).each { |class_| java_import "processing.opengl.#{class_}" }

INITIAL_MODULES = $LOADED_FEATURES.dup

# Base class for Processing sketch
class SketchBase < PApplet
  attr_accessor :is_reload_requested

  %w(displayHeight displayWidth frameCount keyCode
     mouseButton mouseX mouseY pmouseX pmouseY).each do |name|
    re = /(?![a-z])(?=[A-Z])/
    sc_name = name =~ /[A-Z]/ ? name.split(re).map(&:downcase).join('_') : name
    alias_method sc_name, name
  end

  def self.method_added(name)
    name = name.to_s
    lcc_name = name =~ /_/ ? name.split('_').map(&:capitalize).join('') : name
    lcc_name[0] = lcc_name[0].downcase
    alias_method lcc_name, name if lcc_name != name
  end

  def initialize
    super
    @is_reload_requested = false
    SketchBase.run_sketch([SKETCH_TITLE], self)
  end

  def frame_rate(fps = nil)
    get_field_value('keyPressed') unless fps
    super(fps)
  end

  def key
    code = get_field_value('key')
    code < 256 ? code.chr : code
  end

  def key_pressed?
    get_field_value('keyPressed')
  end

  def mouse_pressed?
    get_field_value('mousePressed')
  end

  def reload
    @is_reload_requested = true
  end

  def dispose
    frame.dispose
    super
  end

  def get_field_value(name)
    java_class.declared_field(name).value(to_java(PApplet))
  end
end

loop do
  # create and run sketch
  sketch = nil
  thread = Thread.new do
    begin
      sketch_code = File.read(SKETCH_FILE)
      sketch_code = "class Sketch < SketchBase; #{sketch_code}; end"
      Object.class_eval(sketch_code, SKETCH_FILE)
      sketch = Sketch.new
    rescue Exception => e # rubocop:disable Lint/RescueException
      puts e
    end
  end
  thread.join

  # watch file changed
  execute_time = Time.now

  catch :loop do
    loop do
      sleep(WATCH_INTERVAL)

      Find.find(SKETCH_DIR) do |file|
        is_ruby = FileTest.file?(file) && File.extname(file) == '.rb'
        throw :loop if is_ruby && File.mtime(file) > execute_time
      end

      break if sketch && sketch.is_reload_requested
    end
  end

  # restore execution environment
  sketch.dispose if sketch
  Object.class_eval { remove_const(:Sketch) }

  modules = $LOADED_FEATURES - INITIAL_MODULES
  modules.each { |module_| $LOADED_FEATURES.delete(module_) }
  java.lang.System.gc
end
