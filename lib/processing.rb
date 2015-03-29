if Object.const_defined? :SketchRunner
  require_relative 'processing/system'
  require_relative 'processing/sketch_base'
else
  require_relative 'sketch_runner/config'
  require_relative 'sketch_runner/setup'
  require_relative 'sketch_runner/launch'
end
