# Processing.rb

[ [English](https://github.com/kitao/processing.rb/blob/master/README.md) | [Japanese](https://github.com/kitao/processing.rb/blob/master/README.ja.md) ]

Processing.rbはRubyで気軽にProcessingのスケッチを作成できる実行環境です。

## 特長

他の類似ツールと比べて、Processing.rbには次のような特長があります。

- 1ファイル、250行程度のシンプルなコードのため、気軽に拡張できます。
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

Processing.rbを使うには、Ruby、Java、Processingのインストールが必要です。各ツールは以下のサイトから入手できます。

- [Ruby](https://www.ruby-lang.org/)
- [Java](https://java.com/)
- [Processing](https://processing.org/)

Processingは、Macでは<font color="red">**Applicationsフォルダ**</font>に、Windowsでは<font color="red">**32bit版**</font>を<font color="red">**Cドライブ直下**</font>に配置してください。

### Processing.rbのインストール

Processing.rbはRubyの`gem`コマンドからインストールできます。

```sh
ruby gem install processing.rb
```

インストール時にpermissionエラーが出た場合は、`sudo`コマンドを先頭に追加してください。

また、オフィスなどのプロキシ環境でインストールする場合は、上記コマンドの後ろに、`-p http://proxy.hostname:port`のように[-p オプション](http://guides.rubygems.org/command-reference/#gem-install)でプロキシ設定を追加してください。

## 使い方

### スケッチを作成する

Processing.rbでは、`Processing::SketchBase`クラスの派生クラスとしてスケッチを作成し、`Processing.#start`関数で描画を開始します。

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

`Processing::SketchBase`クラスでは、`HALF_PI`などの定数はJava版のProcessingと同様に使用できます。また、関数や変数は、`noStroke`であれば`no_stroke`のように、Java版の命令を小文字（[スネークケース](http://en.wikipedia.org/wiki/Snake_case)）にしたものが使用できます。

実際のスケッチの作成例は[サンプル](https://github.com/kitao/processing.rb/tree/master/examples)をご覧ください。

作成したスケッチファイルは以下のコマンドで起動できます。

```sh
processing-rb [sketchfile]
```

初回起動時のみ、`~/.processing-rb`ディレクトリにJRubyのダウンロードとサンプルのコピーが行われます。その際、ダウンロードのためのプロキシ設定を聞かれるので、必要な場合は入力を、不必要な場合は何も入力せずEnterを押してしばらくお待ちください。

起動後は、同じディレクトリ以下にある`.rb`ファイルが更新されるたびに、スケッチファイルが自動で再読み込みされます。

### 入力情報を取得する

キーボードやマウスの入力情報は、Java版のProcessingと同様の方法で取得できます。

ただし、Java版の`keyPressed`、`mousePressed`変数は、メソッド名との重複を避けるため、それぞれ`key_pressed?`、`mouse_pressed?`という名前に変更されているのでご注意ください。

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

この例では、マウスボタンが押されると円を描き、キーボードの`R`が押されるとスケッチを再起動します。

### 拡張ライブラリを使用する

Processing向けの拡張ライブラリは、Processing.rbでもそのまま使用できます。

例えば、次のようなVideoライブラリを使用するコードの場合、

```java
import processing.video.*;
Movie movie;

void setup() {
  movie = new Movie(this, "sample.mov");
  movie.loop();
}
```

Processing.rbでは次のようになります。

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

なお、Javaのライブラリへのデータの指定は、絶対パスで行う必要があるため、この例では`Processing.#complete_path`関数を使用して、スケッチファイルからの相対パスを絶対パスに変換しています。

Processingに標準で付属しない拡張ライブラリを使用する場合は、スケッチファイルと同じディレクトリに`libraries`ディレクトリを作成して、そこに使用するライブラリを置いてください。

### ライブコーディングする

`Processing.#start`関数にオプションを指定すると、エディタとスケッチのウィンドウを同時に見やすく表示できます。結果を確認しながらコード編集を行う際に便利です。

```ruby
Processing.start(Sketch.new, topmost: true, pos: [300, 300])
```

`Processing.#start`関数に指定できるオプションは以下のとおりです。

|オプション|説明|
|----|----|
|topmost:|`true`にするとウィンドウを常に最前面に表示する|
|pos:|`[x, y]`で指定した座標にウィンドウを表示する|

## APIリファレンス

### Processingモジュール

`Processing`モジュールはスケッチのためのクラスやメソッドを提供します。

|定数|説明|
|----|----|
|SKETCH_FILE|起動時に指定されたスケッチファイルの絶対パス|
|SKETCH_NAME|ディレクトリ名を除いたスケッチファイル名|
|SKETCH_DIR|スケッチファイルの絶対パスでのディレクトリ名|

|クラス|説明|
|----|----|
|SketchBase|スケッチの基底クラス|

|特異メソッド|説明|
|----|----|
|load_library(name)|指定した拡張ライブラリを読み込む|
|load_jars(dir)|指定したディレクトリのすべての`.jar`ファイルを読み込む|
|import_package(package, module_name)|`module_name`モジュールに、指定したJavaパッケージのすべてのクラスを登録する|
|complete_path(path)|スケッチファイルからの相対パスを絶対パスに変換する|
|start(sketch, topmost: false, pos: nil)|指定したスケッチインスタンスの描画を開始する|
|reload|スケッチファイルを読み込み直し、再起動する|

## ライセンス

Processing.rbは[MITライセンス](http://en.wikipedia.org/wiki/MIT_License)です。無料で自由にご利用ください。

Have fun!
