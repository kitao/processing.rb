# Change Log

## 1.1.0
- Splited the source code into multiple files
- Changed to use as a module with the require command
-

## 1.0.0
- Stable release
- Modified the out messages

## 0.9.9
- Fixed a bug with downloading JRuby without proxy
- Modified the out messages

## 0.9.8
- Updated the READMEs
- Modified the .rubocop.yml file
- Fixed a bug with downloading JRuby via proxy

## 0.9.7
- Changed the way to check the downloaded data
- Modified the ouput messages
- Updated the READMEs

## 0.9.6
- Renamed the command name to processing-rb
- Modified the output messages
- Updated the READMEs

## 0.9.5
- Updated the READMEs
- Changed the directories to search for Processing

## 0.9.4
- Enabled to execute from Ruby
- Changed to download JRuby automatically
- Changed the way to find Processing on Windows

## 0.9.3
- Refactored a variable name
- Renamed sketch_path to complete_path

## 0.9.2
- Updated the license text
- Fixed the SketchBase#frame_rate method

## 0.9.1
- Changed the link to download in README
- Renamed examples/assets to examples/data
- Refined the READMEs
- Removed unnecessary comments

## 0.9.0
- Added README in Japanese
- Resized the screenshots of the examples
- Updated README in English
- Refined comments

## 0.8.0
- Updated the example #5
- Refined the example #3
- Added screenshots of the examples

## 0.7.0
- Changed to run with JRuby explicitly
- Modified the example #3
- Updated the examples #4
- Refined comments in the examples

## 0.6.0
- Added an argument to the import_package method
- Included the Handy library for the example #5
- Added the sketch_path method
- Added movie materials for the example #4

## 0.5.0
- Changed the directory structure of the examples
- Renamed load_all_jars to load_jars
- Renamed import_all_classes to import_package
- Updated the example #3
- Fixed the way to set the initial window status

## 0.4.0
- Refactored the example #1
- Implemented the example #2
- Renamed load_jar_files to loar_all_jars
- Added the import_all_classes method

## 0.3.0
- Simplified the example #1
- Changed to include all of the Processing classes in the module
- Enabled to call a class methods as an instance method

## 0.2.0
- Changed the example #1
- Added the .rubocop.yml file
- Renamed start_sketch to start
- Added options to the start method

## 0.1.1
- Refactored the code
- Added a library search path for Linux
- Started implementing the example #1

## 0.1.0
- Changed the way to undefine the Sketch class
- Fixed the frame_rate method
- Refactored the way to restore the environment
- Changed to wrap the whole code in the Processing module
- Added the descriptions to all of the methods

## 0.0.7
- Refactored the way to adapt to the virtual methods
- Refactored the way to execute and watch the sketch
- Wrote the README.md a little

## 0.0.6
- Wrapped the overloaded fields
- Fixed to adapt to the virtual methods in Processing

## 0.0.5
- Added PROCESSING_ROOT check for libraries
- Added a requirement to the gemspec file
- Changed to call jruby when called from ruby
- Fixed to the library load paths in Windows

## 0.0.4
- Renamed a constant variable
- Added a shebang to the main script
- Changed to use JRuby directly instead of Ruby
- Changed the way to find Processing libraries
- Added error messages

## 0.0.3
- Fixed to set __FILE__ in the sketch
- Removed an unnecessary extension in .gitignore

## 0.0.2
- Added a command existence check
- Adapted the load path to the directory of the sketch
- Fixed to catch all of the errors in the sketch

## 0.0.1
- Initial release
