#!/usr/bin/env ruby

PROGRAM_NAME = 'processing.rb'

if `type jruby 2> /dev/null` == ''
  puts "#{PROGRAM_NAME}: jruby command is not available"
  exit
end

program_file = File.expand_path('../lib/processing.rb', File.dirname(__FILE__))
system("jruby #{program_file} #{ARGV.join(' ')}")
