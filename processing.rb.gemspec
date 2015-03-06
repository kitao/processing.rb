Gem::Specification.new do |spec|
  spec.name          = 'processing.rb'
  spec.version       = '0.9.6'
  spec.author        = 'Takashi Kitao'
  spec.email         = 'takashi.kitao@gmail.com'
  spec.summary       = 'A simple Processing sketch runner for Ruby'
  spec.description   =
    'Processing.rb runs a Processing sketch written in Ruby, ' \
    'and reloads it automatically when files in the same directory change.'
  spec.homepage      = 'https://github.com/kitao/processing.rb'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |file| File.basename(file) }

  spec.requirements << 'java >= 1.8.0_40'
  spec.requirements << 'processing >= 2.2.1'
end
