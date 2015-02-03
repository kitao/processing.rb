# Processing.rb

Processing.rbはRubyで気軽にProcessingのスケッチを作成できる実行環境です。他の同様のツールと比べて、Processing.rbには次のような特長があります。

- 1ファイル、200行程度のシンプルなコードのため、気軽に拡張できます。
- 設定ファイル不要で、MacでもWindowsでも自動で必要なファイルを探します。
- スケッチ更新時に自動で再起動し、requireしたモジュールも再ロードします。
- 本家のProcessing同様、1〜2行のコード追加で簡単に拡張ライブラリが使えます。
- 表示位置の指定や最前面表示など、ライブコーディングに便利な機能があります。

## サンプルギャラリー

サンプルの動作画面です。画像をクリックするとコードが確認できます。

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

## インストール方法

Processing.rbを使うには、事前にProcessingとJRubyのインストールが必要です。各ツールは以下の公式サイトから入手できます。

- [Processing](https://processing.org/)
- [JRuby](http://jruby.org/)

Macであれば、JRubyは[Homebrew](http://brew.sh/)からインストールすることも可能です。

Processing.rbはJRubyのgemコマンドからインストールできます。

```sh
jruby -S gem install processing.rb
```

オフィスなどのプロキシ環境でインストールする場合は、上記コマンドの後ろに、`-p http://proxy.hostname:port`のように[-p オプション](http://guides.rubygems.org/command-reference/#gem-install)でプロキシ設定を追加してください。

## 使い方

### スケッチを作成する

Processing.rbは以下のコマンドでスケッチを起動します。

```sh
jruby -S processing.by [sketchfile]
```

### 入力情報を取得する

xxxxxxxx

### 拡張ライブラリを利用する

xxxxxxxxxxxx

## APIリファレンス

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


## ライセンス

[MITライセンス](http://en.wikipedia.org/wiki/MIT_License)
