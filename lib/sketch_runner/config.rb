module SketchRunner
  VERSION = '1.1.0'

  CONFIG_MTIME = File.stat(__FILE__).mtime

  PACKAGE_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '../..'))

  APPDATA_ROOT = File.expand_path('~/.processing.rb')
  APPDATA_LIB_DIR = File.join(APPDATA_ROOT, 'lib')
  APPDATA_CHECK_FILE = File.join(APPDATA_ROOT, '.complete')

  JRUBY_URL = 'https://s3.amazonaws.com/jruby.org/downloads/9.0.0.0.pre1/jruby-complete-9.0.0.0.pre1.jar'
  JRUBY_FILE = File.join(APPDATA_LIB_DIR, 'jruby/jruby.jar')

  if RUBY_PLATFORM == 'java'
    PLATFORM = :JAVA
  elsif /darwin/ =~ RUBY_PLATFORM
    PLATFORM = :MAC
  elsif /cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM
    PLATFORM = :WINDOWS
  else
    PLATFORM = :LINUX
  end

  PROCESSING_URL = {
    MAC: 'http://download.processing.org/processing-2.2.1-macosx.zip',
    WINDOWS: 'http://download.processing.org/processing-2.2.1-windows32.zip',
    LINUX: 'http://download.processing.org/processing-2.2.1-linux32.tgz'
  }[PLATFORM]

  PROCESSING_CORE_PATH = {
    MAC: 'Processing.app/Contents/Java/core',
    WINDOWS: 'processing-2.2.1/core',
    LINUX: 'processing-2.2.1/core'
  }[PLATFORM]

  PROCESSING_LIBS_PATH = {
    MAC: 'Processing.app/Contents/Java/modes/java/libraries',
    WINDOWS: 'processing-2.2.1/modes/java/libraries',
    LINUX: 'processing-2.2.1/modes/java/libraries'
  }[PLATFORM]

  PROCESSING_DIR = File.join(APPDATA_LIB_DIR, 'processing')
  PROCESSING_ZIP_DIR = File.join(APPDATA_LIB_DIR, 'processing-zip')
  PROCESSING_ZIP_FILE = File.join(PROCESSING_ZIP_DIR, 'processing.zip')

  EXAMPLES_SRC_DIR = File.join(PACKAGE_ROOT, 'examples')
  EXAMPLES_DEST_DIR = File.join(APPDATA_ROOT, 'examples')

  LOAD_PATH = File.join(PACKAGE_ROOT, 'lib')
  STARTUP_FILE = File.join(PACKAGE_ROOT, 'lib/sketch_runner/runner.rb')

  SKETCH_FILE = File.expand_path(ARGV.length > 0 ? ARGV[0] : '')
  SKETCH_DIR, SKETCH_NAME = File.split(SKETCH_FILE)
  SKETCH_LIBS_DIR = File.join(SKETCH_DIR, 'libraries')

  WATCH_INTERVAL = 0.1
end
