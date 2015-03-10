# Provides the classes and methods for a Processing sketch
module Processing
  JRUBY_URL = 'https://s3.amazonaws.com/jruby.org/downloads/9.0.0.0.pre1/jruby-complete-9.0.0.0.pre1.jar'
  WATCH_INTERVAL = 0.1

  COMMAND_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  COMMAND_NAME = 'processing-rb'

  if RUBY_PLATFORM != 'java'
    # set up JRuby and examples
    data_dir = File.expand_path("~/.#{COMMAND_NAME}")
    check_file = File.join(data_dir, '.setup_complete')
    jruby_file = File.join(data_dir, 'lib', File.basename(JRUBY_URL))

    unless File.exist?(check_file) &&
           File.stat(check_file).mtime > File.stat(__FILE__).mtime
      require 'fileutils'
      require 'open-uri'
      require 'openssl'

      FileUtils.remove_dir(data_dir, true)
      FileUtils.mkdir_p(File.dirname(jruby_file))

      puts 'To use Processing.rb, JRuby will be downloaded just one time.'
      puts 'Please input a proxy if necessary, otherwise just press Enter.'
      print "(e.g. 'http://proxy.hostname:port'): "
      proxy = $stdin.gets.chomp

      print "download '#{File.basename(jruby_file)}' ... "
      open(jruby_file, 'wb') do |output|
        open(
          JRUBY_URL,
          ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE,
          proxy: proxy == '' ? nil : proxy
        ) do |data|
          output.write(data.read)
        end
      end
      puts 'done'

      examples_src = File.join(COMMAND_ROOT, 'examples')
      examples_dest = File.join(data_dir, 'examples')
      puts "copy the examples to '#{examples_dest}'"
      FileUtils.copy_entry(examples_src, examples_dest)

      FileUtils.touch(check_file)
    end

    exec("java -jar #{jruby_file} #{__FILE__} #{ARGV.join(' ')}")
  end

  require 'java'
  require 'find'

  if ARGV.size < 1
    puts "usage: #{COMMAND_NAME} [sketchfile]"
    exit
  end

  SKETCH_FILE = File.expand_path(ARGV[0])
  SKETCH_NAME = File.basename(SKETCH_FILE)
  SKETCH_DIR = File.dirname(SKETCH_FILE)

  unless FileTest.file?(SKETCH_FILE)
    puts "sketch file not found -- '#{SKETCH_FILE}'"
    exit
  end

  PROCESSING_LIBRARY_DIRS = [
    File.join(SKETCH_DIR, 'libraries'),
    '/Applications/Processing.app/Contents/Java',
    'C:/processing-*'
  ].flat_map do |dir|
    Dir.glob(dir) + Dir.glob(File.join(dir, 'modes/java/libraries'))
  end

  SYSTEM_REQUESTS = []
  SKETCH_INSTANCES = []

  def self.load_library(name)
    PROCESSING_LIBRARY_DIRS.each do |dir|
      return true if load_jars(File.join(dir, name, 'library'))
    end

    puts "library not found -- '#{name}'"
    false
  end

  def self.load_jars(dir)
    is_success = false

    if File.directory?(dir)
      Dir.glob(File.join(dir, '*.jar')).each do |jar|
        require jar
        is_success = true
        puts "jar file loaded -- '#{File.basename(jar)}'"
      end
      return true if is_success
    end

    false
  end

  def self.import_package(package, module_name)
    code = "module #{module_name}; include_package '#{package}'; end"
    Object::TOPLEVEL_BINDING.eval(code)
  end

  def self.complete_path(path)
    File.join(SKETCH_DIR, path)
  end

  def self.start(sketch, opts = {})
    title = opts[:title] || SKETCH_NAME
    topmost = opts[:topmost]
    pos = opts[:pos]

    PApplet.run_sketch([title], sketch)

    SYSTEM_REQUESTS << { command: :topmost, sketch: sketch } if topmost
    SYSTEM_REQUESTS << { command: :pos, sketch: sketch, pos: pos } if pos
  end

  def self.reload
    SYSTEM_REQUESTS << { command: :reload }
  end

  exit unless load_library 'core'
  include_package 'processing.core'
  include_package 'processing.opengl'

  # The base class of a Processing sketch
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
      return get_field_value('frameRate') unless fps
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

  INITIAL_FEATURES = $LOADED_FEATURES.dup
  INITIAL_CONSTANTS = Object.constants - [:INITIAL_CONSTANTS]

  loop do
    # run sketch
    print "\n****** START SKETCH ******\n\n"

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
