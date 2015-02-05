# Processing.rb

Processing.rb enables you to write various Processing sketches in Ruby easily.

## Features

Compared to similar tools, Processing.rb has the following features:

- Consists of a file with about two hundreds lines, and easy to extend by yourself
- Unnecessary the setting files and finds related files automatically on both of Mac and Windows
- Reloads the sketch and included modules automatically when the sketch files are updated
- Available to use extention libraries with only adding a few line code like the original Processing
- Supports useful functions help with live-coding, such as specifying the window position and draw the window always on top

## Screenshots

The followings are screenshots of the examples of Processing.rb. The actual codes can be seen when each image is clicked.

<a href="https://github.com/kitao/processing.rb/blob/master/examples/01_simple_sketch.rb" target="_blank">
<img
src="https://raw.githubusercontent.com/kitao/processing.rb/master/examples/screenshots/01_simple_sketch.png" width="30%">
</a>
<a href="https://github.com/kitao/processing.rb/blob/master/examples/02_input_handling.rb" target="_blank">
<img
src="https://raw.githubusercontent.com/kitao/processing.rb/master/examples/screenshots/02_input_handling.png" width="30%">
</a>
<a href="https://github.com/kitao/processing.rb/blob/master/examples/03_multi_file.rb" target="_blank">
<img src="https://raw.githubusercontent.com/kitao/processing.rb/master/examples/screenshots/03_multi_file.png" width="30%">
</a>

<a href="https://github.com/kitao/processing.rb/blob/master/examples/04_builtin_library.rb" target="_blank">
<img src="https://raw.githubusercontent.com/kitao/processing.rb/master/examples/screenshots/04_builtin_library.png" width="30%">
</a>
<a href="https://github.com/kitao/processing.rb/blob/master/examples/05_external_library.rb" target="_blank">
<img src="https://raw.githubusercontent.com/kitao/processing.rb/master/examples/screenshots/05_external_library.png" width="30%">
</a>

The examples can also be downloaded from [this link](https://github.com/kitao/processing.rb/archive/master.zip).

## How to Install

### Preparations

For using Processing.rb, installations of Processing and JRuby are required. Each tool can be available in the following site:

- [Processing](https://processing.org/)
- [JRuby](http://jruby.org/)

In the case of Mac, JRuby can also be installed from [Homebrew](http://brew.sh/).

### Installing Processing.rb

Processing.rb can be installed via the `gem` command of JRuby.

```sh
jruby -S gem install processing.rb
```

In a proxy environment such as in an office, please attach the proxy setting with [-p option](http://guides.rubygems.org/command-reference/#gem-install), like `-p http://proxy.hostname:port`

## How to Use

### Creates a sketch

In Processing.rb, a sketch can be created with deriving the `Processing::SketchBase` class, and it starts drawing by calling the `Processing.#start` function.

```ruby
class Sketch < Processing::SketchBase
  def setup
    # implement your own setup code
  end

  def draw
    # implement your own draw code
  end
end

Processing.start(Sketch.new)
```

In the `Processing::SketchBase` class, the constans of Processing in Java like `HALF_PI` can be used in the same way. Regarding the functions and variables of Processing, [snake-cased](http://en.wikipedia.org/wiki/Snake_case) names are available, for example, `no_stroke` for `noStroke` in Java.

Please check [the examples](https://github.com/kitao/processing.rb/tree/master/examples) of actual sketch codes.

Sketches run by the following command.

```sh
jruby -S processing.rb [sketchfile]
```

After running the sketch file, it will be reloaded automatically when the `.rb` files in the same directory are updated.

### Handles input data

The information of the keyboard and mouse can be obtained in the same way of the Java-version Processing.

Please note that the `keyPressed` and `mousePressed` methods in Java are renamed to `key_pressed?` and `mouse_pressed?` to avoid duplication of the names.

```ruby
def draw
  if mouse_pressed?
    ellipse(mouse_x, mouse_y, 10, 10)
  end
end

def key_pressed
  Processing.reload if key == 'r'
end
```

This example draws circles when the mouse button is pressed, and restarts the sketch when the `R` key is pressed.

### Uses extension libraries

Extension libraries for Processing can be used in Processing.rb in the same way.

For example, in the case of the sketch uses the video extension library like this:

```java
import processing.video.*;
Movie movie;

void setup() {
  movie = new Movie(this, "sample.mov");
  movie.loop();
}
```

In Processing.rb, it goes as follow:

```ruby
Processing.load_library 'video'
Processing.import_package 'processing.video', 'Video'

class Sketch < Processing::SketchBase
  def setup
    @movie = Video::Movie.new(self, Processing.sketch_path('sample.mov'))
    @mov1.loop
  end
  ...
```

Note that: specifying data paths in Processing.rb, it should be expressed as the absolute path, so this example converts the relative path to the absolute path with `Processing.#sketch_path` method.

In the case of using extension libraries which is not bundled in Processing, please make the `libraries` directory in the same directory of the sketch file and put the library there.

### Do live coding

By setting options to the `Processing.#start` function, it is possible to display the both of an editor screen and a sketch's window more visible so that it gets easier to edit the sketch with checking the drawing results.

```ruby
Processing.start(Sketch.new, topmost: true, pos: [300, 300])
```

The options of the `Processing.#start` function are as follows:

|Option|Description|
|----|----|
|topmost:|When its value is `true`, the sketch window always appears in the topmost|
|pos:|The sketch window appears in the position `[x, y]`|

## API Reference

### Processing module

Processing module provides the classes and methods for a Processing sketch.

|Constant|Description|
|----|----|
|SKETCH_FILE|The path of the sketch file in the absolute path|
|SKETCH_BASE|The name of the sketch file without the directory|
|SKETCH_DIR|The directory of the sketch file in the absolute path|

|Class|Description|
|----|----|
|SketchBase|The base class of a Processing sketch|

|Method|Description|
|----|----|
|load_library(name)|Loads the specified processing library|
|load_jars(dir)|Loads all of the `.jar` files in the specified directory|
|import_package(package, module_name)|Imports all of the classes in the package to the specified module|
|sketch_path(path)|Converts the relative path from the sketch directory to the absolute path|
|start(sketch, topmost: false, pos: nil)|Starts the specified sketch instance|
|reload|Reloads the sketch file manually|

## License

Processing.rb is under [MIT license](http://en.wikipedia.org/wiki/MIT_License). Feel free to use it.

Have fun!
