if RUBY_PLATFORM != 'java'
  require 'fileutils'
  require 'open_uri_redirections'
  require 'openssl'
  require 'zip'

  require_relative 'processing/config'
  require_relative 'processing/setup'
  require_relative 'processing/launch'
else
  require_relative 'processing/config'
  require_relative 'processing/system'
  require_relative 'processing/sketch_base'
end
