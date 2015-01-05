#!/usr/bin/env ruby

COMMAND_NAME = 'processing.rb'

if `type jruby 2> /dev/null` == ''
  puts "#{COMMAND_NAME}: 'jruby' command not found"
  exit
end

program_file = File.expand_path('../lib/processing.rb', File.dirname(__FILE__))
system("jruby #{program_file} #{ARGV.join(' ')}")
