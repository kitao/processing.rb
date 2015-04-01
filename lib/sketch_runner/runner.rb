require 'find'
require_relative 'config'

# Runs a sketch and reloads it when related files change
module SketchRunner
  class << self
    def system_requests
      @system_requests ||= []
    end

    def sketch_instances
      @sketch_instances ||= []
    end
  end

  def self.start
    $PROGRAM_NAME = ARGV.shift

    jars = File.join(PROCESSING_DIR, 'core/library/*.jar')
    Dir.glob(jars).each { |jar| require jar }

    initial_constants = Object.constants
    initial_features = $LOADED_FEATURES.dup

    loop do
      puts '****** START SKETCH ******'

      run_sketch
      watch_file_changes
      restore_environment(initial_constants, initial_features)
    end
  end
  private_class_method :start

  def self.run_sketch
    Thread.new do
      begin
        Object::TOPLEVEL_BINDING.eval(File.read(SKETCH_FILE), SKETCH_FILE)
      rescue Exception => e
        puts e
      end
    end
  end
  private_class_method :run_sketch

  def self.watch_file_changes
    execute_time = Time.now

    catch :break_loop do
      loop do
        system_requests.each do |request|
          system_requests.delete(request) if respond_to_request(request)
        end

        Find.find(SKETCH_DIR) do |file|
          is_ruby = FileTest.file?(file) && File.extname(file) == '.rb'
          throw :break_loop if is_ruby && File.mtime(file) > execute_time
        end

        sleep(WATCH_INTERVAL)
      end
    end
  end
  private_class_method :watch_file_changes

  def self.respond_to_request(request)
    case request[:command]
    when :topmost
      sketch = request[:sketch]
      sketch.frame.set_always_on_top(true)

      return sketch.frame.is_always_on_top
    when :pos
      sketch = request[:sketch]
      pos_x, pos_y = request[:pos]
      sketch.frame.set_location(pos_x, pos_y)

      cur_pos = sketch.frame.get_location
      return cur_pos.x == pos_x && cur_pos.y == pos_y
    when :reload
      throw :break_loop
    end
  end
  private_class_method :respond_to_request

  def self.restore_environment(initial_constants, initial_features)
    sketch_instances.each do |sketch|
      sketch.frame.dispose
      sketch.dispose
    end

    sketch_instances.clear
    system_requests.clear

    added_constants = Object.constants - initial_constants
    added_constants.each do |constant|
      Object.class_eval { remove_const constant }
    end

    added_features = $LOADED_FEATURES - initial_features
    added_features.each { |feature| $LOADED_FEATURES.delete(feature) }

    java.lang.System.gc
  end
  private_class_method :restore_environment

  start
end
