# Processing.rb

[ [English](https://github.com/kitao/processing.rb/blob/master/README.md) | [Japanese](https://github.com/kitao/processing.rb/blob/master/README.ja.md) ]

Processing.rb enables you to write various Processing sketches in Ruby easily.

## Features

Compared to similar tools, Processing.rb has the following features:

- Consists of a single file with about 250 lines of code and easy to extend by yourself
- Requires no configuration file and detects Processing-related files automatically on both Mac and Windows
- Reloads the sketch file and used modules automatically when the related files are updated
- Available to use extension libraries for Processing with just adding a few line code in the same way as Processing
- Provides useful functions for live coding, such as setting the window position and showing it in the topmost

## Screenshots

The following are screenshots of the examples of Processing.rb. Click each image to view the source code.

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

The examples can be downloaded [here](https://github.com/kitao/processing.rb/releases).

## How to Install

### Preparations

In order to use Processing.rb, installation of Java and Processing is required. Each tool can be obtained from the following sites:

- [Java](https://java.com/)
- [Processing](https://processing.org/)

In the case of Mac, Processing must be installed to **the Applications folder**. In the case of Windows, **the 32-bit version** of Processing must be installed to **the root directory of the C drive**.

### Installing Processing.rb

Processing.rb can be installed with the `gem` command of Ruby.

```sh
gem install processing.rb
```

If a permission error occured while installation, please add the `sudo` command at the head of the above command.

In a proxy environment such as in an office, please add a proxy configuration as [-p option](http://guides.rubygems.org/command-reference/#gem-install) at the end of the above command, such as `-p http://proxy.hostname:port`.

## How to Use

### Creating a sketch

In Processing.rb, a sketch is created as a derived class from the `Processing::SketchBase` class. And it starts rendering by calling the `Processing.#start` function.

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

In the `Processing::SketchBase` class, the constants of Processing in Java such as `HALF_PI` can be used as the same name. Regarding the functions and variables of Processing, their names are [snake-cased](http://en.wikipedia.org/wiki/Snake_case). For example, `no_stroke` in the case of `noStroke` in Java.

Please check the actual code in [the examples](https://github.com/kitao/processing.rb/tree/master/examples).

A sketch file can be run with the following command:

```sh
processing-rb [sketchfile]
```

Only for the first time, JRuby will be downloaded and the examples will be copied to the `~/.processing-rb` directory. The proxy setting to download will be asked at that moment. Please input it or just press `Enter` without any input if not necessary, and wait for a while.

While the sketch file is running, it will be reloaded automatically when the `.rb` files in the same directory are updated.

### Handling input data

The information of the keyboard and mouse can be obtained in the same way as Processing in Java.

But please note that the `keyPressed` and `mousePressed` methods in Java are renamed to `key_pressed?` and `mouse_pressed?` to avoid duplication of the names.

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

### Using an extension library

An extension library for Processing can be used in Processing.rb in the same way as Processing in Java.

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
    @movie = Video::Movie.new(self, Processing.complete_path('sample.mov'))
    @movie.loop
  end
  ...
```

When a data path is specified in Processing.rb, it should be an absolute path. So this example uses the `Processing.#complete_path` function to convert the relative path from the sketch directory to the absolute path.

In the case of using an extension library not bundled in Processing, please make the `libraries` directory in the same directory as the sketch file and place the library in it.

### Live coding

With passing optional parameters to the `Processing.#start` function, the both an editor screen and a sketch window can get more visible. It helps with editing a sketch in parallel with checking its rendering result.

```ruby
Processing.start(Sketch.new, topmost: true, pos: [300, 300])
```

The options of the `Processing.#start` function are as follows:

|Option|Description|
|----|----|
|topmost:|When its value is `true`, the sketch window always appears in the topmost.|
|pos:|The sketch window appears in the position `[x, y]`.|

## API Reference

### Processing module

The `Processing` module provides the classes and methods for a Processing sketch.

|Constant|Description|
|----|----|
|SKETCH_FILE|The path of the sketch file in the absolute path|
|SKETCH_NAME|The name of the sketch file without the directory|
|SKETCH_DIR|The directory of the sketch file in the absolute path|

|Class|Description|
|----|----|
|SketchBase|The base class of a Processing sketch|

|Method|Description|
|----|----|
|load_library(name)|Loads the specified processing library|
|load_jars(dir)|Loads all of the `.jar` files in the specified directory|
|import_package(package, module_name)|Imports all of the classes in the specified Java package to the specified module|
|complete_path(path)|Converts the relative path from the sketch directory to the absolute path|
|start(sketch, topmost: false, pos: nil)|Starts to render the specified sketch instance|
|reload|Reloads the sketch file manually|

## License

Processing.rb is under [MIT license](http://en.wikipedia.org/wiki/MIT_License). Feel free to use it.

Have fun!
