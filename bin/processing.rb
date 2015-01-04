#!/usr/bin/env ruby

programfile = File.expand_path('../lib/processing.rb', File.dirname(__FILE__))
arguments = ARGV.join(' ')
system("jruby #{programfile} #{arguments}")
