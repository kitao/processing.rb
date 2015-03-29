require_relative 'lib/sketch_runner/config'

Gem::Specification.new do |spec|
  spec.name         = 'processing.rb'
  spec.version      = SketchRunner::VERSION
  spec.author       = 'Takashi Kitao'
  spec.email        = 'takashi.kitao@gmail.com'
  spec.summary      = 'A simple Processing sketch runner for Ruby'
  spec.description  =
    'Processing.rb runs a Processing sketch written in Ruby, ' \
    'and reloads it automatically when files in the same directory change.'
  spec.homepage     = 'https://github.com/kitao/processing.rb'
  spec.license      = 'MIT'
  spec.files        = `git ls-files -z`.split("\x0")
  spec.requirements = ['java >= 1.8.0_40']
  spec.add_runtime_dependency 'open_uri_redirections', '~> 0.2.1'
  spec.add_runtime_dependency 'rubyzip', '~> 1.1.7'
end
