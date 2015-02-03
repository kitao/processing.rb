昨年末から開発を始めた[Processing.rb](https://github.com/kitao/processing.rb)が、ようやく皆様に使っていただけるレベルの完成度になりましたので、今日は真面目な紹介記事を書きたいと思います。

なお、今回の紹介記事をベースに後日日本語版のREADMEを作成する予定です。

<!-- more -->

# Processing.rbとは

Processing.rbはRubyで気軽にProcessingのスケッチを作成できる実行環境です。他の同様のツールと比べて、Processing.rbはこんなところが違います。

- 1ファイル、200行程度のシンプルなコードのため、気軽に拡張できます。
- 設定ファイル不要で、MacでもWindowsでも自動で必要なファイルを探します。
- スケッチ更新時に自動で再起動し、requireしたモジュールも再ロードします。
- 本家のProcessing同様、1〜2行のコード追加で簡単に拡張ライブラリが使えます。
- 表示位置の指定や最前面表示など、ライブコーディングに便利な機能があります。

# ギャラリー

<div width="45%">
<img src="https://raw.githubusercontent.com/kitao/processing.rb/master/examples/screenshots/01_simple_sketch.png">
<p>hgoe</p>
</div>

<a href="https://raw.githubusercontent.com/kitao/processing.rb/master/examples/screenshots/01_simple_sketch.png" target="_blank">
<img
src="https://raw.githubusercontent.com/kitao/processing.rb/master/examples/screenshots/02_input_handling.png" width="45%">
</a>
<a href="https://raw.githubusercontent.com/kitao/processing.rb/master/examples/screenshots/01_simple_sketch.png" target="_blank">
<img src="https://raw.githubusercontent.com/kitao/processing.rb/master/examples/screenshots/03_multi_file.png" width="45%">
</a>
<a href="https://raw.githubusercontent.com/kitao/processing.rb/master/examples/screenshots/01_simple_sketch.png" target="_blank">
<img src="https://raw.githubusercontent.com/kitao/processing.rb/master/examples/screenshots/04_builtin_library.png" width="45%">
</a>
<a href="https://raw.githubusercontent.com/kitao/processing.rb/master/examples/screenshots/01_simple_sketch.png" target="_blank">
<img src="https://raw.githubusercontent.com/kitao/processing.rb/master/examples/screenshots/05_external_library.png" width="45%">
</a>

https://github.com/kitao/processing.rb/blob/master/examples/01_simple_sketch.rb

https://github.com/kitao/processing.rb/blob/master/examples/02_input_handling.rb

https://github.com/kitao/processing.rb/blob/master/examples/03_multi_file.rb

https://github.com/kitao/processing.rb/blob/master/examples/04_builtin_library.rb

https://github.com/kitao/processing.rb/blob/master/examples/05_external_library.rb

# インストール方法

Processing.rbを動かすには、事前にProcessingとJRubyのインストールが必要です。それぞれのツールは以下の公式サイトから入手できます。

- [Processing](https://processing.org/)
- [JRuby](http://jruby.org/)

Macであれば、JRubyは[Homebrew](http://brew.sh/)からインストールすることも可能です。

Processing.rbは、次のようにJRubyのgemコマンドからインストールします。

```sh
jruby -S gem install processing.rb
```

オフィスなどのプロキシ環境でインストールする場合は、コマンドの後ろに`-p http://proxy.hostname:port`のように[-p オプション](http://guides.rubygems.org/command-reference/#gem-install)でプロキシ設定をつけてください。

# スケッチを作成する


```sh
jruby -S processing.by [sketchfile]
```

# 入力を取得する


# 拡張ライブラリを使用する


# APIリファレンス

** Processingモジュール **

|定数|説明|
|--|--|
|SKETCH_FILE|起動時に指定されたスケッチファイル|
|SKETCH_BASE|ディレクトリ名を除いたスケッチファイル|
|SKETCH_DIR|スケッチファイルのディレクトリ名|
|SketchBase|スケッチのベースクラス|

|メソッド|説明|
|--|--|
|load_library(name)||
|load_jars(dir)||
|import_package(package, module_name)||
|sketch_path(path)|スケッチファイルからの相対パスを絶対パスに変換する|
|start(sketch, topmost: false, pos: nil)|スケッチを開始する|
|reload|スケッチファイルを再読み込みする|

** Processing::SketchBaseクラス **

|メソッド|説明|
|--|--|
|key_pressed?   |xx|
|mouse_pressed? |xx|


  # Procesingライブラリの使い方


  # ライセンス

  - MITライセンス


  Getting Started
  Examples
  Documentation
