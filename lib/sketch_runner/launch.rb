# Runs a sketch and reloads it when related files change
module SketchRunner
  def self.launch
    jruby_opts = "-I#{LOAD_PATH}"
    jruby_args = "#{STARTUP_FILE} #{$PROGRAM_NAME} #{ARGV.join(' ')}"
    exec("java -jar #{JRUBY_FILE} #{jruby_opts} #{jruby_args}")
  end
  private_class_method :launch

  launch
end
