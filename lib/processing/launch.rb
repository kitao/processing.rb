module Processing
  def self.launch
    jruby_args = "#{STARTUP_FILE} #{$PROGRAM_NAME} #{ARGV.join(' ')}"
    exec("java -jar #{JRUBY_FILE} -I#{LOAD_PATH} #{jruby_args}")
  end

  private_class_method :launch

  launch
end
