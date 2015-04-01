# Provides the classes and methods for a Processing sketch
module Processing
  include_package 'processing.core'
  include_package 'processing.opengl'

  # The base class of a Processing sketch
  class SketchBase < PApplet
    %w(displayHeight displayWidth frameCount keyCode
       mouseButton mouseX mouseY pmouseX pmouseY).each do |name|
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
      SketchRunner.sketch_instances << self
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
end
