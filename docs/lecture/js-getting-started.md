# JavaScript(ES6) 入門

あんはるです。
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

そして、`typeof `(スペースを忘れずに)の後に調べたい値を入れましょう。

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

###　文字列型
文字列は、`""`か`''`（タブルクオートかシングルクオート）で囲みます。

数字でも、`""`か`''`で囲めば、文字列になるのです。

文字列同士を連結することもできます。

```bash
> "Hello " + "Sakuten"
'Hello Sakuten'
```

数字を文字列にすることもできます

```bash
> (1).toString()
'1'
> const n = 2
undefined
> n.toString()
'2'
```

### 数字型
数字は、何かで囲む必要はないです。
```bash
> 1
1
> 1.3
1.3
> 0
0
```

文字列を数字にするには`parseInt()`で囲みます。
```
> parseInt("1")
1
```

足し算、引き算、割り算、掛け算、余りの計算もできます。
```bash
> 1 + 1
2
> 3 - 1
2
> 4 / 2
2
> 5 % 2
1
```

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
const 定数の名前 = 値
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


## 戻り値（返り値）
値は値自体を返します（当たり前ですが）。

あとで話す関数というものも戻り値があります。

関数は、何も返さないこともできますし（undefinedを返すとも言える）、値を返すこともできます。

`console.log`も関数で何も返さないのでundefinedとターミナルに表示されました。

つまり、JavaScriptを実行した後に表示されるものは、戻り値なのです。

## 関数
処理のまとまりです。値を受け取ることもでき、値を返すことができます。

このように定義します。

```
const 関数の名前 = (受け取る値) => {
  処理
}
```
値を返すときは、

```
const 関数の名前 = (受け取る値) => {
  処理
  return　返す値
}
```
または

```
const 関数の名前 = (受け取る値) => (返す値)
```

```
const 関数の名前 = (受け取り値) => 返す値
```
かっこを省略することもできます。

受け取る値が必要ないときは、`()`にします。

実行するときは

```
関数の名前(受け取る値)
```
です。
例えば、`"Hello"`を返す関数なら

```
> const returnHello = () => "Hello"
undefined
> returnHello()
'Hello'
> console.log(returnHello())
Hello
undefined
```

受け取った文字に`"Hello"`をつけて表示する関数なら

```shell
> const sayHello = (name) => {
... const newName = "Hello " + name
... console.log(newName)
... }
undefined
> sayHello("Anharu")
Hello Anharu
undefined
```

`console.log()`や`parseInt()`も関数なのです。

##　Object（オブジェクト）
Objectも型の一つです。

値をまとめて入れておける箱です。

Objectの宣言の仕方

```
const Objectの名前 = {
  キー: 値,
  キー: 値,
  キー: 値
}
```
最後のコロン（,）はなくてもあっても良いです。

Objectは、キーと値というものがあって、キーはその値の名前です。

Objectが変数として宣言されれば、値を変更することやキーを追加したりすることができます。

自分のプロフィールのObjectを作ってみましょう。

```
> let myProfile = {
... name: "Anharu",
... age: 14,
... club: "Monoken"
... }
undefined
> myProfile
{ name: 'Anharu', age: 14, club: 'Monoken' }
```

値を変更するには
```
> myProfile.name = "Ando"
'Ando'
> myProfile
{ name: 'Ando', age: 14, club: 'Monoken' }
```
値にアクセスするには
```
> myProfile.name
'Ando'
```
キーを追加するには
```
> myProfile.hobby = "Programming"
'Programming'
> myProfile
{ name: 'Ando', age: 14, club: 'Monoken', hobby: 'Programming' }
```

## 配列
配列は、値を並べておける箱です。

配列を宣言するには
```
const 配列の名前 = [値, 値, 値]
```
配列が変数として宣言されてれば、値を変更したり、値を追加したりできます。

クラスの配列を作ってみましょう。

```
> let classList = ["A", "B", "C", "D"]
undefined
```
n番目の値をアクセスするには、
```
classList[n - 1]
```
とします。
`"B"`をアクセスしたいなら、

```shell
> classList[1]
'B'
```
値を追加するには
```
> classList.push("E")
5
> classList
[ 'A', 'B', 'C', 'D', 'E' ]
```

それぞれに`"1"`を追加して配列を返して欲しいときは
```bash
> firstClassList = classList.map(name => "1" + name)
[ '1A', '1B', '1C', '1D', '1E' ]
> firstClassList
[ '1A', '1B', '1C', '1D', '1E' ]
```
これは、mapの中の関数の戻り値が、出来上がった配列の値となるのです。

それぞれを表示させたいときは
```bash
> classList.forEach(name => console.log(name))
A
B
C
D
E
undefined
```

配列に関して詳しいことはここに書いてます。
https://qiita.com/takeharu/items/d75f96f81ff83680013f

## ファイルにプログラムを書いて実行してみよう

### Windowsの方
PowerShellを開いてください。
```
ii sakuten.js
```
と入力してみましょう、すると、sakuten.jsが作られます。

そして、エクスプローラでsakuten.jsを開いてみましょう。

好きなエディターでいいですが、まだ持っていないなら、メモ帳で大丈夫です。

開いたら好きなプログラムを書いてみましょう。
```
console.log("Hello, Sakuten")
```
入力して、セーブします。PowerShellに戻って、
```
node sakuten.js
Hello, Sakuten
```
エラーが出ずに実行できれば成功です！

### Macの方
ターミナルを開いてください。
```
touch sakuten.js
```
と入力してみましょう、すると、sakuten.jsが作られます。

そして、Finderでsakuten.jsを開いてみましょう。

好きなエディターでいいですが、まだ持っていないなら、テキストエディットで大丈夫です。

開いたら好きなプログラムを書いてみましょう。
```
console.log("Hello, Sakuten")
```
入力して、セーブします。ターミナルを開いて、
```
node sakuten.js
Hello, Sakuten
```
エラーが出ずに実行できれば成功です！

# 練習問題
配列`numberList`のそれぞれ値をn足した値が表示される関数を作りなさい。


### 正解

```js
const numberList = [1,0,3,10,5]
const n = 10
const addEachNumber = (numerList, n) => {
  numberList.forEach(num => console.log(num + n))
}

addEachNumber(numberList, n)
```
関数の受け取る値のnumberList,nと最初の宣言しているnumberList,nは違うものと考えましょう。

# まとめ
JavaScriptを難しいと感じた方もいるかもしれませんが、慣れれば簡単です。

覚える必要もありません、分からなければ調べればいいのです。

Discordや創作展システムの人に気になることを質問してみましょう。

創作展システムでJavaScriptが使われている部分は、
https://github.com/Sakuten/frontend
ここを見ればわかります。
