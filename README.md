# Remort Shogi board.

ネットワーク経由で動作させられる将棋盤です

最低限必要な機能がそろっていないのでまだリリース前です。

## 特徴

* Rubyのみで記述されています

## 機能
### できること
* リモートで盤面の表示
* 通常の将棋盤と同様の事をリモートで出来る

### 未実装
* ２歩チェック
* 駒の動きチェック
* 先手後手をどうするか
* 持ち時間等
* 観客機能
* 振り駒機能
* LOG機能(棋譜)
* 待った機能
* 参りました機能

## 使い方

### 準備
bundle install --path vendor/bundle

### 起動方法
* サーバーを起動
 * bundle exec ruby jcserver.rb
* クライアントを起動
 * bundle exec ruby jcclient.rb

### オプション
-help ヘルプを表示する
-i, --ipaddr [VALUE]             引数付きオプション(デフォルトlocalhost)
-p, --port [VALUE]               ポート番号指定(デフォルト1117)

## コマンド

### 盤面を表示する

print

### 駒を指す

７七の駒を７六へ動かす
move 77 76

### 駒台から駒を打つ

７四に歩を打つ
set 74 fu

* 駒の指定
 * 王/玉 : fu
 * 金    : kin
 * 銀    : gin
 * 桂    : kei
 * 香    : kyo
 * 歩    : fu
 * 飛    : hi
 * 角    : kaku
