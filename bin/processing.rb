#!/usr/bin/env jruby

require 'java'
require 'find'

# Provides classes and methods for Processing sketches
module Processing
  COMMAND_NAME = File.basename(__FILE__)

  if ARGV.size < 1
    puts "Usage: #{COMMAND_NAME} [sketchfile]"
    exit
  end

  SKETCH_FILE = File.expand_path(ARGV[0])
  SKETCH_BASE = File.basename(SKETCH_FILE)
  SKETCH_DIR = File.dirname(SKETCH_FILE)

  unless FileTest.file?(SKETCH_FILE)
    puts "#{COMMAND_NAME}: Sketch file not found -- '#{SKETCH_FILE}'"
    exit
  end

  PROCESSING_LIBRARY_DIRS = [
    File.join(SKETCH_DIR, 'libraries'),
    File.expand_path('Documents/Processing/libraries', '~'),
    File.expand_path('sketchfolder/libraries', '~'),
    ENV['PROCESSING_ROOT'] || '/dummy',
    '/Applications/Processing.app/Contents/Java',
    File.join(ENV['PROGRAMFILES'] || '/dummy', 'processing-*'),
    File.join(ENV['PROGRAMFILES(X86)'] || '/dummy', 'processing-*'),
    'C:/processing-*'
  ].flat_map do |dir|
    Dir.glob(dir) + Dir.glob(File.join(dir, 'modes/java/libraries'))
  end

  SYSTEM_REQUESTS = []
  SKETCH_INSTANCES = []
  WATCH_INTERVAL = 0.1

  # Loads the specified processing library
  def self.load_library(name)
    PROCESSING_LIBRARY_DIRS.each do |dir|
      return true if load_jars(File.join(dir, name, 'library'))
    end

    puts "#{COMMAND_NAME}: Library not found -- '#{name}'"
    false
  end

  # Loads all of the jar files in the specified directory
  def self.load_jars(dir)
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

  # Imports all of the classes in the package to the specified module
  def self.import_package(package, module_name)
    code = "module #{module_name}; include_package '#{package}'; end"
    Object::TOPLEVEL_BINDING.eval(code)
  end

  # Converts the relative path from the sketch directory to the absolute path
  def self.sketch_path(path)
    File.join(SKETCH_DIR, path)
  end

  # Starts the specified sketch instance
  def self.start(sketch, opts = {})
    title = opts[:title] || SKETCH_BASE
    topmost = opts[:topmost]
    pos = opts[:pos]

    PApplet.run_sketch([title], sketch)

    SYSTEM_REQUESTS << { command: :topmost, sketch: sketch } if topmost
    SYSTEM_REQUESTS << { command: :pos, sketch: sketch, pos: pos } if pos
  end

  # Reloads the sketch file manually
  def self.reload
    SYSTEM_REQUESTS << { command: :reload }
  end

  exit unless load_library 'core'
  include_package 'processing.core'
  include_package 'processing.opengl'

  # The base class for Processing sketches
  class SketchBase < PApplet
    %w(
      displayHeight displayWidth frameCount keyCode
      mouseButton mouseX mouseY pmouseX pmouseY
    ).each do |name|
      sc_name = name.split(/(?![a-z])(?=[A-Z])/).map(&:downcase).join('_')
      alias_method sc_name, name
    end

    def self.method_added(name)
      name = name.to_s
      if name.include?('_')
        lcc_name = name.split('_').map(&:capitalize).join('')
        lcc_name[0] = lcc_name[0].downcase
        alias_method lcc_name, name if lcc_name != name
      end
    end

    def method_missing(name, *args)
      self.class.__send__(name, *args) if PApplet.public_methods.include?(name)
    end

    def get_field_value(name)
      java_class.declared_field(name).value(to_java(PApplet))
    end

    def initialize
      super
      SKETCH_INSTANCES << self
    end

    def frame_rate(fps = nil)
      return get_field_value('keyPressed') unless fps
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
  end

  def self.const_missing(name)
    SketchBase.const_get(name)
  end

  INITIAL_FEATURES = $LOADED_FEATURES.dup
  INITIAL_CONSTANTS = Object.constants - [:INITIAL_CONSTANTS]

  loop do
    # create and run sketch
    Thread.new do
      begin
        Object::TOPLEVEL_BINDING.eval(File.read(SKETCH_FILE), SKETCH_FILE)
      rescue Exception => e
        puts e
      end
    end

    # watch file changed
    execute_time = Time.now

    catch :break_loop do
      loop do
        SYSTEM_REQUESTS.each do |request|
          case request[:command]
          when :topmost
            sketch = request[:sketch]
            sketch.frame.set_always_on_top(true)

            is_always_on_top = sketch.frame.is_always_on_top
            SYSTEM_REQUESTS.delete(request) if is_always_on_top
          when :pos
            sketch = request[:sketch]
            pos_x, pos_y = request[:pos]
            sketch.frame.set_location(pos_x, pos_y)

            cur_pos = sketch.frame.get_location
            is_pos_set = cur_pos.x == pos_x && cur_pos.y == pos_y
            SYSTEM_REQUESTS.delete(request) if is_pos_set
          when :reload
            throw :break_loop
          end
        end

        Find.find(SKETCH_DIR) do |file|
          is_ruby = FileTest.file?(file) && File.extname(file) == '.rb'
          throw :break_loop if is_ruby && File.mtime(file) > execute_time
        end

        sleep(WATCH_INTERVAL)
      end
    end

    # restore execution environment
    SKETCH_INSTANCES.each do |sketch|
      sketch.frame.dispose
      sketch.dispose
    end

    SKETCH_INSTANCES.clear
    SYSTEM_REQUESTS.clear

    added_constants = Object.constants - INITIAL_CONSTANTS
    added_constants.each do |constant|
      Object.class_eval { remove_const constant }
    end

    added_features = $LOADED_FEATURES - INITIAL_FEATURES
    added_features.each { |feature| $LOADED_FEATURES.delete(feature) }

    java.lang.System.gc
  end
end
