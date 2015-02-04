# Processing.rb

Processing.rbはRubyで気軽にProcessingのスケッチを作成できる実行環境です。

## 特長

他の同様のツールと比べて、Processing.rbには次のような特長があります。

- 1ファイル、200行程度のシンプルなコードのため、気軽に拡張できます。
- 設定ファイル不要で、MacでもWindowsでも自動で必要なファイルを探します。
- スケッチ更新時に自動で再起動し、requireしたモジュールも再ロードします。
- 本家のProcessing同様、1〜2行のコード追加で簡単に拡張ライブラリが使えます。
- 表示位置の指定や最前面表示など、ライブコーディングに便利な機能があります。

## 動作画面

サンプルの動作画面です。画像をクリックすると実際のコードが確認できます。

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

サンプル一式は[こちら](https://github.com/kitao/processing.rb/releases)からダウンロードできます。

## インストール方法

### 事前準備

Processing.rbを使うには、事前にProcessingとJRubyのインストールが必要です。各ツールは以下の公式サイトから入手できます。

- [Processing](https://processing.org/)
- [JRuby](http://jruby.org/)

Macであれば、JRubyは[Homebrew](http://brew.sh/)からインストールすることも可能です。

### Processing.rbのインストール

Processing.rbはJRubyのgemコマンドからインストールできます。

```sh
jruby -S gem install processing.rb
```

オフィスなどのプロキシ環境でインストールする場合は、上記コマンドの後ろに、`-p http://proxy.hostname:port`のように[-p オプション](http://guides.rubygems.org/command-reference/#gem-install)でプロキシ設定を追加してください。

## 使い方

### スケッチを作成する

Processing.rbではProcessing::SketchBaseクラスを派生させてスケッチを作成します。

```ruby
class Sketch < Processing::SketchBase
  def setup
    # implement your own setup code
  end

  def draw
    # implement your own draw code
  end
end

Processing::start(Sketch.new)
```

描画命令は、`noStroke`であれば`no_stroke`のように、Java版の命令を小文字（[スネークケース](http://en.wikipedia.org/wiki/Snake_case)）にしたものが使用できます。

作成したスケッチは以下のコマンドで起動します。

```sh
jruby -S processing.by [sketchfile]
```

起動したスケッチは、更新されるたびに自動的に再読み込みされます。

### 入力情報を取得する

キーボードやマウスの入力情報は、Java版のProcessingと同様の方法で取得できます。

ただし、Java版の`keyPressed`、`mousePressed`変数は、メソッド名との重複を避けるため、それぞれ`key_pressed?`、`mouse_pressed?`という名前に変更されています。

```ruby
def draw
  if mouse_pressed?
    ellipse(mouse_x, mouse_y, 50, 50)
  end
end

def key_pressed
  Processing.reload if key == 'r'
end
```

この例では、マウスがクリックされると円を描き、キーボードのRが押されるとスケッチを再スタートします。


### 拡張ライブラリを利用する

Processing向けの拡張ライブラリは、Processing.rbでもそのまま使用できます。

例えば、次のようなJava版のコードであれば、

```java
import processing.video.*;
Movie movie;

void setup() {
  movie = new Movie(this, "sample.mov");
  movie.loop();
}
```

Rubyでは次のような形で利用できます。

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

なお、`Processing.sketch_path`メソッドはスケッチからの相対パスでリソースを読み込む際に使用します。

### ライブコーディングする

定義したスケッチクラスは、`Processing.start`メソッドにインスタンスを渡すとウィンドウが表示されます。

その際に次のようにオプションを指定することでライブコーディングをしやすくすることができます。

```ruby
Processing.start(Sketch.new, topmost: true, pos: [300, 300])
```

- `topmost:`オプションは`true`にするとウィンドウを常に最前面に表示します。
- `pos:`オプションは`[x, y]`で指定した位置にウィンドウを表示します。

エディタとウィンドウを共存させる際に利用して下さい。

## APIリファレンス

### Processingモジュール

|定数|説明|
|----|----|
|SKETCH_FILE|起動時に指定されたスケッチファイル|
|SKETCH_BASE|ディレクトリ名を除いたスケッチファイル|
|SKETCH_DIR|スケッチファイルのディレクトリ名|

|クラス|説明|
| -- | -- |
|SketchBase|スケッチの基底クラス|

|特異メソッド|説明|
| -- | -- |
|load_library(name)||
|load_jars(dir)||
|import_package(package, module_name)||
|sketch_path(path)|スケッチファイルからの相対パスを絶対パスに変換する|
|start(sketch, topmost: false, pos: nil)|スケッチを開始する|
|reload|スケッチファイルを再読み込みする|

### Processing::SketchBaseクラス

|メソッド|説明|
| -- | -- |
|key_pressed?   |xx|
|mouse_pressed? |xx|


## ライセンス

Processing.rbは[MITライセンス](http://en.wikipedia.org/wiki/MIT_License)です。無料で自由に利用できます。
