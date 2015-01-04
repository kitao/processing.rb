Gem::Specification.new do |spec|
  spec.name          = 'processing.rb'
  spec.version       = '0.0.1'
  spec.author        = 'Takashi Kitao'
  spec.email         = 'takashi.kitao@gmail.com'
  spec.summary       = 'A simple Processing sketch runner for JRuby'
  spec.description   =
    'processing.rb runs a Processing sketch written in JRuby, ' \
    'and reloads it automatically when files in the same directory change.'
  spec.homepage      = 'https://github.com/kitao/processing.rb'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |file| File.basename(file) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ["lib"]
end
