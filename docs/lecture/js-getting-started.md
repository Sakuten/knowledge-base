# JavaScript(ES6) 入門

創作展システムでも実際に使われてるJavaScriptを初心者向けに教えます。

# まずは必要なものをインストール

WindowsとMacの方ではインストール方法が違います。
Node.jsというものをインストールしましょう。

#### Windowsの方のインストール方法

[インストール方法はこちら](https://qiita.com/Masayuki-M/items/840a997a824e18f576d8)

#### Macの方のインストール方法

[インストール方法はこちら](https://qiita.com/kyosuke5_20/items/c5f68fc9d89b84c0df09)

# JavaScriptを実行してみよう!
Windowsの方は、Windows PowerShell（デフォルトで入ってるはずです）、Macの方はTerminal.appを開いて
`node`と打ってみましょう。

```
node
>
```

`node`と打つと、`>`が表示されるはずです。
そして、`console.log("Hello! Sakuten")`と打ってみましょう。

```bash
node
> console.log("Hello! Sakuten")
Hello! Sakuten
undefined
>

```
これであなたはJavaScriptを実行することができました。
`console.log()`というのを使って文字を表示することができます。
まだ`undefined`というのは気にしないでくださいね。


# プログラミングの基本の概念

## 型
プログラミングで使われる値には型があります。

JavaScriptでは、例えば
`"Hello"`なら、string型（文字列型）、`1`なら、number型（数字型）となります。

これはあなたも調べることができるので調べてみましょう。
さっきと同じように、ターミナルでnodeと打ちましょう。

そして、`typeof `(スーペすを忘れずに)の後に調べたい値を入れましょう。

```bash
node
> typeof "hello"
'string'
> typeof 'hello'
'string'
> typeof 1
'number'
> typeof "1"
'string'
```

値には必ず型が存在します。
プログラミングするときにこの値はどの型なのか分かっていないといけません。

上からもわかるように
文字列は、`""`か`''`（タブルクオートかシングルクオート）で囲み、数字は囲む必要がありません。
数字でも、`""`か`''`で囲めば、文字列になるのです。

## 定数

定数は、値を名前が付いてる透明な箱の中に入れて、テープでぐるぐる巻いて、閉じ込めておくことです。
透明な箱に入っているので値を見ることができます。
そして、もうその箱は開けることができないので、値を入れかえることはできません。

定数を作ってみましょう。

```shell
 node
 > const name = "Hello! Sakuten"
 undefined
 > console.log(name)
 Hello! Sakuten
 undefined
 >
```

まず、

```
const 定数の名前（箱の名前）= 値
```

という構文で、定数を定義します。
そうすると、`name`が`"Hello! Sakuten"`の代わりとして使えるのです。

```
console.log(name)
```

もし値を変更しようとすれば

```
> name = "Hello! Koishikawa"
TypeError: Assignment to constant variable.""
```
このようなエラーが出ます。

## 変数
変数は、定数と違って、値を変更することができます。
しかし、できるだけ定数を使うことをお勧めします。

定義の仕方は

```
let 変数の名前（箱の名前）= 値
```

値を変えたいときは、
```
変えたい変数の名前　= 新しい値
```
です。

```shell
node
> let name = "good"
undefined
> console.log(name)
good
undefined
> name = "bad"
'bad'
> console.log(name)
bad
undefined
> name = "great"
'great'
> console.log(name)
great
undefined
```
こうやって、何度でも値を変更することができます。
