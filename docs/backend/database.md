# データベース取扱説明

「データベースとは何か？」というところから、`flask_sqlalchemy`を用いたデータベースモデル構築の解説までを行います。

ソースコードにある各モデルの正確な情報についてはAPI（もしくはソースコード中のドキュメントコメント）を参照してください。

ごちゃごちゃしてる部分もあるので、わからなくなったら適宜Discordで聞いたり、「データベースとは」「SQLAlchemy使い方」などのようにググってみてください。

検索テクニックですが、時には日本語よりも英語で検索したほうが情報がより出てくることがあります。[公式ドキュメント](https://docs.sqlalchemy.org/en/latest/orm/)も最新版は英語で、古いバージョンの日本語ドキュメントもなんかいろいろ不足しているので、やはり英語に慣れていると役に立つことがあると思います。テストとかでも活きるかもね。

一人で頭を悩ませるよりは、人に聞くほうがずっと早いし、全体の時間を無駄にしません。遠慮なく篠川（shino）なんかに聞いてください。

## Q: データベースってなに？

## A: あとで使いやすいように整理されたデータです。

例えば、実際の創作展の運用で、誰かがどこかの劇に応募したとしましょう。

この時、「応募先」「応募者」「複数人応募であるか」などといった情報が、応募者の端末（スマホ）から送られてきます。

こういった情報を、あとで抽選するときに**検索しやすいように**、**構造的に情報を整理する**必要があります。

これを実現する仕組みが、**データベース(database, DB)**と呼ばれるものです。

## Q: じゃあ創作展のサーバでは、実際どのように情報が整理されてるの？

## A: リレーショナルモデルにより、応募先、ユーザー、応募情報などにまとめています。**

先ほどの応募の例で考えましょう。

抽選時に送られてくるのは、以下のような情報です。

+ 応募先ID
+ 応募者ID
+ 複数人申し込みの代表者かどうか

これらをひとまとめの情報の集まり、**レコード(record)**として扱います。
実際にはこれらに、「現在の状態（デフォルトで『抽選待ち』）」「複数人申し込みのほかのメンバー」などの情報が加わることもあります。

このレコードを集めたものが、**テーブル(table)**と呼ばれるものです。
実際には、`application`という名前のテーブルに、上記レコードがたくさん整理されて保存されているわけです。

またこれらの「応募者ID」などのテーブルの持つ情報の種類を**カラム(column)**と呼び、各レコード中のそれぞれの情報は**フィールド(field)**と呼ばれます。

―分かりにくいですね。きっと[このサイト](https://academy.gmocloud.com/know/20160425/2259)の説明が分かりやすいです。

そして重要なのが、この`application`以外に`user`、`lottery`などたくさんのテーブルがあり、その中のレコード同士が**紐付けられている**ということです。

つまり、1つ`application`のレコードを見つけたら、それに対応する`user`（応募者の情報・状態）や`lottery`（応募先）のレコードに**芋づる式にたどり着ける**ようになっているのです。

この仕組みは**リレーショナルモデル(relational model)**といい、それを使ったデータベースは**リレーショナルデータベース(relational database)**と呼ばれます。

## とりあえず使ってみよう

さて、では実際にプログラムの書き方を、手を動かしながら学びましょう。

まず、`backend`ディレクトリ内で[このページ](https://qiita.com/5t111111/items/7852e13ace6de288042f)を参考に、IPythonをインストールすることをおすすめします。

それでは`pipenv run ipython`と入力してください。
`In [1]:`と出てきたらOKです。

分からなければDiscordにお越しください。

では、次の文を入力してください。
`>>> `は`In [n]:`の代わりなので、みなさんが入力する部分ではありません。

```python
>>> from flask_sqlalchemy import SQLAlchemy
>>> db = SQLAlchemy()
>>> from flask import Flask
>>> app = Flask(__name__)
>>> db.init_app(app)  # 警告が出るけどここでは無視
C:\Users\W\.virtualenvs\backend-T-5B7hGY\lib\site-packages\flask_sqlalchemy\__init__.py:774: UserWarning: Neither SQLALCHEMY_DATABASE_URI nor SQLALCHEMY_BINDS is set. Defaulting SQLALCHEMY_DATABASE_URI to "sqlite:///:memory:".
  'Neither SQLALCHEMY_DATABASE_URI nor SQLALCHEMY_BINDS is set. '
>>> app.app_context().push()
```

※豆知識：上矢印キーを押すと、入力の履歴をさかのぼれます。

`flask_sqlalchemy`はパッケージ名（≒ライブラリ）で、そこに含まれる`SQLAlchemy`というものを使うよ、と言っています。

実は、[`SQLAlchemy`](https://docs.sqlalchemy.org/en/latest/)はもともと別のライブラリで、
[`Flask-SQLAlchemy`](http://flask-sqlalchemy.pocoo.org/2.3/)（今使用しているもの）は`Flask`パッケージと一緒に使うように改変されたパッケージです。

ですので、`SQLAlchemy`本体の使い方を知りたいときは、そちらのほうで検索したほうがより多くの情報が得られるかもしれません。

次に定義した`db`は、`Flask-SQLAlchemy`内の`SQLAlchemy`本体だと思えば大丈夫です（多分そう）。

では、次はこちら。

```python
>>> class Student(db.Model):
...   id = db.Column(db.Integer, primary_key=True)    # 整数
...   name = db.Column(db.String)                     # 文字列
...   def __repr__(self):
...     return f'<Student No.{self.id} {self.name}>'  # fは必要
... #  ←何も入力せずにEnter
>>> db.create_all()
```

まず`db.Model`を継承することで、舞台裏の配線のほとんどを`SQLAlchemy`がやってくれます。ここで`student`は晴れてデータベースのテーブルとなりました。

カラムは`カラム名 = db.Column(型, その他オプション)`というものを並べていって定義します。

型というものはフィールドの形態で、整数、文字列、日付、小数など、いくつか種類があります。よく使うものは[Flask-SQLAlchemyのサイト](http://flask-sqlalchemy.pocoo.org/2.3/models/)に、一覧は[SQLAlchemyのサイト](https://docs.sqlalchemy.org/en/latest/core/type_basics.html)にあります。

その下の`__repr__`関数は単に表示を見やすくするためだけに書いています。

細かい説明は後回しにして、さっそく使ってみましょう。


では`student`のレコードを作成していきます。

```python
>>> alice = Student(id=1, name="Alice")
>>> alice
<Student No.1 Alice>
>>> alice.id
1
>>> alice.name
'Alice'
>>> bob = Student(id=2, name="Bob")
>>> bob
<Student No.2 Bob>
>>> carol = Student(name="Carol")   # あとで説明
>>> carol
<Student No.None Carol>
```

次に、このレコードをデータベースに追加します。

```python
>>> db.session.add(alice)
>>> db.session.add(bob)
>>> db.session.add(carol)
>>> db.session.commit()
```

さて、これで完了です。3つのレコードはデータベースに追加されました。

このように、`add`で追加したいものを書いてから、`commit`で初めて実際に追加されます。

データベースの書き込みは**非常に時間のかかる**作業です。Alice、Bob、Carolとレコードを作るたびに書き込みしていては、時間がかかってしまいます。
そこで、`add`したものをためておいて、`commit`でまとめて書き込んでいます。

では、追加されたレコードを見てみましょう。レコードは`Student.query.○○`という操作で参照できます。

```python
>>> students = Student.query.all()
>>> students
[<Student No.1 Alice>, <Student No.2 Bob>, <Student No.3 Carol>]
>>> students[0]
<Student No.1 Alice>
>>> whatever = Student.query.first()
>>> whatever
<Student No.1 Alice>
>>> bob_found = Student.query.filter_by(name='Bob').first()
>>> bob_found
<Student No.2 Bob>
>>> id3 = Student.query.filter_by(id=3).first()
>>> id3
<Student No.3 Carol>
>>> id3 = Student.query.get(3)
>>> id3
<Student No.3 Carol>
```

いろいろな操作が用意されています。一覧を見たいときのために[こちら](https://docs.sqlalchemy.org/en/latest/orm/query.html#sqlalchemy.orm.query.Query)を一応貼っておきます。

さて、ここで`carol`のidがいつの間にか設定されていたことに気づいたでしょうか。

`carol`を作成した時、`id`は設定しませんでしたね。

実は、`primary_key=True`とした`id`カラムは、いちいち設定しなくても自動で設定してくれるのです。ただし、`id`の重複は認められません。気になる場合は自分でレコードを作って`commit`で追加しようとしてみることをおすすめします。

実際には、今回の`alice`や`bob`のように`id`を設定することはまずありません。

それから、`primary_key=True`を設定できるカラムは、テーブルごとに１つ必ず設ける必要があります。

また、下の例からもわかるように、`id`以外のカラムが自動で設定されることもありません（ただし、後でもさらっと触れますが、カラムによってはデフォルト値が設定されていることもあります）。

```python
>>> anonymous = Student()
>>> anonymous
<Student No.None None>
>>> db.session.add(anonymous)
>>> db.session.commit()
>>> anonymous
<Student No.4 None>
```

以上が基本的なデータベースの扱い方です。
気になるところなどあれば、DiscordかGoogleへ。

## リレーションって何なの？

さて、ここからは実際のソースコードを見ていきましょう。データベースの定義系は`api/models.py`に集められています。

`unique=True`（重複なし）やら`default=0`（設定しなかった場合のデフォルト値）やらがありますが、大体は理解できるのではないでしょうか。

しかし、100行目周辺で見たことのないやつが出てきます。例えば、`Application`テーブルのこいつ：

```python
    user_id = db.Column(db.Integer, db.ForeignKey(
        'user.id', ondelete='CASCADE'))
    user = db.relationship('User')
```

この`db.ForeignKey`、`db.relationship`とやらは何を意味するのでしょうか。

これをIpythonで、簡略化して再現してみましょう。`pipenv run ipython`です。

以下を入力します。

```python
>>> class MyUser(db.Model):
...     id = db.Column(db.Integer, primary_key=True)
...     public_id = db.Column(db.Integer)
...     def __repr__(self):
...         return f'<User.{self.id} {self.public_id}>'
...
>>> class MyApplication(db.Model):
...     id = db.Column(db.Integer, primary_key=True)
...     user_id = db.Column(db.Integer, db.ForeignKey('my_user.id'))
...     user = db.relationship('MyUser')
...     def __repr__(self):
...         return f'<Application.{self.id} {self.user}>'
...
>>> db.create_all()   # 忘れない！
```

これで（簡略化した）`my_user`テーブルと`my_application`テーブルができました。`MyUser`は`User`（応募する人）、`MyApplication`は`Application`（１回の応募データ、応募先など）の簡単バージョンです。

一応ここでちょっとしたことを説明しておくと、`MyUser`とか`Student`というのは実際にレコードを作成するときのクラス名で、厳密にはテーブル名ではありません。実際は`my_user`、`student`のように、先頭が小文字になったものがデフォルトでテーブル名として使用されています。

さて、この`class MyUser`の定義は、今までと全く同じものです。問題は`MyApplication`の方ですね。

実際にどんな事が起きるのか、実験してみましょう。

```python
>>> taro = MyUser(public_id=1111)
>>> jiro = MyUser(public_id=2222)
>>> db.session.add(taro)
>>> db.session.add(jiro)
>>> db.session.commit()
>>> MyUser.query.all()
[<User.1 1111>, <User.2 2222>]
>>> taro
<User.1 1111>
```

ここまではいつもどおりです。エラーメッセージなど出てきたら、Discordに報告をお願いします。

では、いよいよ`MyApplication`をデータベースに追加していきましょう。まずはパラメータなしでやってみます。

```python
>>> x = MyApplication()
>>> x
<Application.None None>
>>> db.session.add(x)
>>> db.session.commit()
>>> x
<Application.1 None>
>>> x.user_id
>>> x.user_id is None
True
>>> x.user is None
True
```

何も面白いことは起きていませんね。何も設定していないので、`primary_key=True`の`id`が`1`となっているだけで、あとはすべて`None`です。

では今度は、`public_id`を設定してみます。

```python
>>> taroApplication = MyApplication(user_id=taro.id)
>>> db.session.add(taroApplication)
>>> db.session.commit()
>>> taroApplication
<Application.2 <User.1 1111>>
>>> taroApplication.user == taro
True
```

何が起きたかわかりましたか。

まず、`taroApplication`を作成するとき、`user_id`に`user`のレコードの1つ、`taro`の`id`を渡しましたね。
`MyApplication`にある`user_id = db.Column(db.Integer, db.ForeignKey('my_user.id'))`の`ForeignKey`というのは、「`my_user`テーブルのレコードの`id`がここに入る」という意味だったのです。

そしてこの`taroApplication`をデータベースに追加したときに、`taroApplication.user`が`taro`に設定されました。`taroApplication`を作ったときには`user_id`しか設定しなかったにもかかわらずです。

なんとな区、わかってきたでしょうか。

`MyApplication`の`user = db.relationship('MyUser')`とは、「`ForeignKey`の情報をもとに、`MyUser`オブジェクトをここに結びつけておいてね」ということでした。

このオブジェクト同士の結びつき（ここでは`MyUser`である`taro`と、`MyApplication`の`taroApplication`）が、**リレーション**と呼ばれるものです。

ちなみに、１つの`my_user`に対して、複数の`my_application`を関連付けることもできます。つまり、`taroApplication2`とかがいくらでも作れるよ、ということです。実際の創作運用をイメージすればわかりやすいのではないでしょうか。１人が１日に何度もいろんなクラスに応募しますよね。ここらへんの`relationship`の関係について詳しく知りたいということがあったら`SQLAlchemy`の[公式ドキュメント](https://docs.sqlalchemy.org/en/latest/orm/basic_relationships.html)を参照したり、"One to Many" "One to One"などとググってみてください。

この他、いろいろ実験してみてください。`taroApplication.user_id = jiro.id`などのように情報を書き換えてデータベースに追加し直すと、何が起きるでしょうか（`db.session.commit()`を忘れずに）。

１つ補足として、ソースコードの`ForeignKey`には`ondelete='CASCADE'`というのがついていますが、これは「`relastionships`先がデータベースから削除されたら、自分自身もデータベースから削除する」という意味です。

## `GroupMember`がなんかごちゃごちゃしてるんだが

【注意】ここから先はなかなかマニアックです。目を通しておく文にはいいかもしれませんが、ちょっと重いかもしれません。わからないことがあったときに参照するくらいの使い方がいいかもしれません。あと、わかりにくかったら篠川（shino）にDiscordで聞いてね。

団体応募は、代表者の`Application`に対して「こういうメンバーが一緒に応募してるよ」という情報を付け加えることによって実現しています。この「こういうメンバー」の部分が、まさに`GroupMember`です。

`GroupMember`には、３つの`ForeignKey`、３つの`relationship`がありますね。`member`という`GroupMember`オブジェクトがあったとき、`member.user`が「こういうメンバー」の`User`オブジェクト、`member.own_application`がその人自身の応募データ（`Application`）、そして`member.rep_application`が代表者の`Application`を指しています。

これら３つを`SQLAlchemy`は見つけてきてリレーションを引く必要があるわけですが、`Application`を指す`relationships`、`ForeignKey`が２つづつあるので、どの`relation`をどの`ForeignKey`を頼りに持ってくればいいのかわからなくなるのです。

これを助けるのが、`foreign_keys=[...]`というやつですね。

もう１つ説明するのは`backref`ですね。ここに自身のテーブル名（ここでは`__tablename__ = 'group_members'`と最初の方に指定されていますね）を渡すことで、`GroupMember`から`rep_application`というリレーションが張られるだけでなく、`representative`を代表者の`Application`としたときに、`representative.group_members`と、逆向きのリレーションも自動的に追加されるのです。魔法みたいですね。

## ソースコードの`Application`について―何だこいつら

【注意】この項の情報は、今年仕様変更により、ソースコードから消えている可能性があります。それでも、`SQLAlchemy`の内部的な動作について知りたいことがあれば、これが参考になるかもしれません。

ソースコードの`Application`を見ると、`db.Column`以外に`advantage`とか、`get_advantage`とか、わけのわからん者たちがいますね。

実は今まで、`alice`や`taroApplication`など、Python上のオブジェクトをデータベースに追加するような言い方をしてきました。実際そのように扱えるように設計されているのですが、内部的に厳密に言うと、少し違います。

もう一度`alice`の例を見てみましょう。

```python
>>> alice = Student(id=1, name="Alice")
>>> db.session.add(alice)
>>> db.session.commit()
```

この`db.session.add`と`db.session.commit`でデータベースに追加されるのは、`alice`という`Student`クラスのオブジェクトではなく、`alice.id`、`alice.name`という`db.Column`たちです。

Excelをイメージしてみてください。``SQLAlchemy`の内部では、`alice`や`bob`はこのように見えています。

|     | id |  name |
|----:|:--:|:-----:|
|alice|  1 |"alice"|
| bob |  2 | "bob" |

`db.session.add`、`db.session.commit`でデータベースに登録されるのは、これらの`db.Column`として宣言したものだけです。

ここでもう一度`Application`を見てください。

`advantage`などの`db.Column`でないフィールドや、`get_advantage`、`__repr__`などの関数は、データベースに追加する際にすべて無視されるのです。

実験しましょう。

```python
>>> class MyApp2(db.Model):
...     id = db.Column(db.Integer, primary_key=True)
...     column = db.Column(db.Integer)
...     field = -1
...     def __repr__(self):
...         return f'<MyApp2.{self.id} column={self.column} field={self.field}>'
...
>>> db.create_all()       # 忘れない！
>>> def addApp2(c, f):
...     t = MyApp2(column=c)
...     t.field = f
...     print("add", t, "to the db")
...     db.session.add(t)
...     db.session.commit()
...
>>> addApp2(1, 2)
add <MyApp2.1 column=1 field=2> to the db
>>> addApp2(4, 8)
add <MyApp2.2 column=4 field=8> to the db
>>> MyApp2.query.all()
[<MyApp2.1 column=1 field=-1>, <MyApp2.2 column=4 field=-1>]
```

`column`と`field`を設定してからデータベースに追加したにもかかわらず、データベースから取り出してみると、`field`の情報だけが消えてしまいましたね。

`SQLAlchemy`は、`db.session.commit`が呼ばれると、`db.Column`たち（ここでは`id`と`column`）**のみ**をデータベースに保存し、そうでない情報（`field`）は**捨てられます**。

その後`〇〇.query`が使用されてデータベースの情報を取り出す段になると、`id`と`column`をデータベースから引き出して、`MyApp2(id=xx, column=xx)`のように`MyApp2`オブジェクトを作り直し、`MyApp2.query.all()`の結果として返されるわけです。ここで`field`は捨てられるわけです。

※ここでさらに内部的にごにょごにょしたことを言うと、いままでの`alice`や`taroApplication`などの例では、`add(x)`したときからオブジェクト（`alice`、`taroApplication`）が残っています。それを`SQLAlchemy`は把握していて、いちいち作り直さずに`alice`、`taroApplication`と全く同じオブジェクトを返しています。これは`alice is Student.query.filter_by(name="Alice").first()`とやれば確かめられます（この`is`による比較は、`alice`と`Student.query....`がメモリ上の全く同じものを指している場合のみ`True`になります）。

実験するには、`m = MyApp2(column=xx)`のように入力して、`field`を設定してデータベースに追加し、もう一度`MyApp2.query.all()`してみてください。こちらの場合は`field`情報が保たれているでしょう。上のように`is`を使えば、`m`と`query.all()`で返される`MyApp2`オブジェクトが全く同じものを指していることがわかるはずです。

さて、話題をソースコードに戻します。`Application`の`advantage`はユーザーが応募したとき（＝データベースに`Application`を追加するとき）に計算されるのではなく、抽選時に応募者の人数やグループ応募か否かなどによってその場で（＝データベースから`Application`を取り出した後）計算されるものです。なので`db.Column`としてデータベースに保存するのではなく、取り出した後の`Application`オブジェクトのフィールドして後から代入する形となっています。`draw.py`の`set_group_advantage`なども参照してください。


## お疲れ様でした！

長々とお読みいただきありがとうございます。大変でしたね。書くのも大変でした。

`SQLAlchemy`は公式ドキュメントも含めてなんかいろいろ闇な感じがあって、読んでもわからないので自分は実験を繰り返してちょっとずつ理解していきました。

後の世代でも同じことを繰り返さないように、（繰り返しになりますが）わからないことは聞くという事を忘れないでください。

なかなか扱いは大変でしたが、あとの人たちが困らずに済むことを願っています。
