if RUBY_PLATFORM != 'java'
  require_relative 'sketch_runner/config'
  require_relative 'sketch_runner/setup'
  require_relative 'sketch_runner/launch'
else
  require_relative 'processing/system'
  require_relative 'processing/sketch_base'
end
