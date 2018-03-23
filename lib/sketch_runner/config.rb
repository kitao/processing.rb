# Runs a sketch and reloads it when related files change
module SketchRunner
  VERSION = '1.1.1'

  CONFIG_MTIME = File.stat(__FILE__).mtime

  PACKAGE_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '../..'))

  APPDATA_ROOT = File.expand_path('~/.processing.rb')
  APPDATA_CHECK_FILE = File.join(APPDATA_ROOT, '.complete')

  JRUBY_URL = 'https://s3.amazonaws.com/jruby.org/downloads/9.1.13.0/jruby-complete-9.1.13.0.jar'
  JRUBY_FILE = File.join(APPDATA_ROOT, 'jruby/jruby.jar')

  if RUBY_PLATFORM == 'java'
    BIT_SIZE = java.lang.System.getProperty('sun.arch.data.model') == '64' ?
      64 : 32
  else
    require 'open3'
    BIT_SIZE = Open3.capture3('java -version')[1].include?('64-Bit') ? 64 : 32
  end

  if RUBY_PLATFORM == 'java'
    PLATFORM = :JAVA
  elsif /darwin/ =~ RUBY_PLATFORM
    PLATFORM = :MACOSX
  elsif /cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM
    PLATFORM = BIT_SIZE == 32 ? :WIN32 : :WIN64
  else
    PLATFORM = BIT_SIZE == 32 ? :LINUX32 : :LINUX64
  end

  PROCESSING_URL = {
    MACOSX: 'http://download.processing.org/processing-2.2.1-macosx.zip',
    WIN32: 'http://download.processing.org/processing-2.2.1-windows32.zip',
    WIN64: 'http://download.processing.org/processing-2.2.1-windows64.zip',
    LINUX32: 'http://download.processing.org/processing-2.2.1-linux32.tgz',
    LINUX64: 'http://download.processing.org/processing-2.2.1-linux64.tgz'
  }[PLATFORM]

  if PLATFORM == :MACOSX
    PROCESSING_CORE_PATH = 'Processing.app/Contents/Java/core'
    PROCESSING_LIBS_PATH = 'Processing.app/Contents/Java/modes/java/libraries'
  else
    PROCESSING_CORE_PATH = 'processing-2.2.1/core'
    PROCESSING_LIBS_PATH = 'processing-2.2.1/modes/java/libraries'
  end

  PROCESSING_DIR = File.join(APPDATA_ROOT, 'processing')
  PROCESSING_ZIP_DIR = File.join(APPDATA_ROOT, 'processing-zip')
  PROCESSING_ZIP_FILE = File.join(PROCESSING_ZIP_DIR, 'processing.zip')

  EXAMPLES_SRC_DIR = File.join(PACKAGE_ROOT, 'examples')
  EXAMPLES_DEST_DIR = File.expand_path('~/processingrb_examples')

  LOAD_PATH = File.join(PACKAGE_ROOT, 'lib')
  STARTUP_FILE = File.join(PACKAGE_ROOT, 'lib/sketch_runner/runner.rb')

  SKETCH_FILE = File.expand_path(ARGV.length > 0 ? ARGV[0] : '')
  SKETCH_DIR, SKETCH_NAME = File.split(SKETCH_FILE)
  SKETCH_LIBS_DIR = File.join(SKETCH_DIR, 'libraries')

  WATCH_INTERVAL = 0.1
end
