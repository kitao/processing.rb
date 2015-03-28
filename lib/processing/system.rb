# Provides the classes and methods for a Processing sketch
module Processing
  def self.load_library(name)
    if load_jars(File.join(PROCESSING_DIR, name, 'library')) ||
       load_jars(File.join(SKETCH_DIR, name, 'library'))
      true
    else
      puts "library not found -- #{name}"
      false
    end
  end

  def self.load_jars(dir)
    is_success = false

    if File.directory?(dir)
      Dir.glob(File.join(dir, '*.jar')).each do |jar|
        require jar
        is_success = true
        puts "jar file loaded -- #{File.basename(jar)}"
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
end
