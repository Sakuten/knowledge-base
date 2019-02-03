# データベース取扱説明書

篠川です。

「データベースとは何か？」というところから、`flask_sqlalchemy`を用いたデータベースモデル構築の解説までを行います。

各モデルのプロパティについてはAPI（もしくはソースコード中のドキュメンテーションコメント）を参照してください。

専門用語がたくさん出てくるので、わからなくなったら適宜Discordで聞いたり、「データベースとは　初心者」などのようにググってみてください。

検索テクニックですが、時には日本語よりも英語で検索したほうが情報がより出てくることがあります。どのライブラリのAPIやチュートリアルも、たいてい英語です。怖がらずに英語を読んで、効率的に情報を仕入れましょう。がんばれ～～

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
実際にはこれらに、「現在の状態（デフォルトで『抽選待ち』）」、「複数人申し込みのほかのメンバー」などの情報が加わることもあります。

このレコードを集めたものが、**テーブル(table)**と呼ばれるものです。
実際には、`application`という名前のテーブルに、上記レコードがたくさん整理されて保存されているわけです。

またこれらの「応募者ID」などのテーブルの持つ情報の種類を**カラム(column)**と呼び、各レコード中のそれぞれの情報は**フィールド(field)**と呼ばれます。

―分かりにくいですね。きっと[このサイト](https://academy.gmocloud.com/know/20160425/2259)の説明が分かりやすいです。

そして重要なのが、この`application`以外に`user`、`lottery`などたくさんのテーブルがあり、その中のレコード同士が**紐付けられている**ということです。

つまり、一つ`application`のレコードを見つけたら、それに対応する`user`（応募者の情報・状態）や`lottery`（応募先）のレコードに**芋づる式にたどり着ける**ようになっているのです。

この仕組みは**リレーショナルモデル(relational model)**といい、それを使ったデータベースは**リレーショナルデータベース(relational database)**と呼ばれます。

## 専門用語ばっかで疲れた―さっさと使ってみようよ

さて、では実際にプログラムの書き方を、手を動かしながら学びましょう。

まず`backend`ディレクトリで`pipenv run python`と入力してください。
`Python 3.6.7 (...)`と出てきたらOKです。

分からなければDiscordにお越しください。

では、次の文を入力してください

```python
>>> from flask_sqlalchemy import SQLAlchemy
>>> db = SQLAlchemy()
```

`flask_sqlalchemy`はパッケージ名（≒ライブラリ）で、そこに含まれる`SQLAlchemy`というものを使うよ、と言っています。

実は、[`SQLAlchemy`](https://docs.sqlalchemy.org/en/latest/)はもともと別のライブラリで、
[`Flask-SQLAlchemy`](http://flask-sqlalchemy.pocoo.org/2.3/)は`Flask`パッケージと一緒に使うように改良されたパッケージです。

ですので、`SQLAlchemy`本体の使い方を知りたいときは、そちらのほうで検索したほうがより多くの情報が得られるかもしれません。ただし書き方などいろいろな違いはあるので、要注意です。

そして次に定義した`db`は、SQLAlchemyの本体だと思えば大丈夫です。

では、次はこちら。

```python
>>> class Student(db.Model):
...   id = db.Column(db.Integer, primary_key=True)
...   name = db.Column(db.String(20))
...   def __repr__(self):
...     return f'<Student No.{self.id} {self.name}>'
...   ←何も入力せずにEnter
```

この`Student`は、私たちが作った最初のテーブルです。`id`カラムと`name`カラムを持っています。

まず`db.Model`を継承することで、舞台裏の配線のほとんどを`SQLAlchemy`がやってくれます。ここで`Student`は晴れてデータベースのテーブルとなりました。

カラムの定義は`カラム名 = db.Column(型, その他オプション)`というものを並べていくことで簡単にできます。

型というものはフィールドの形態で、整数、文字列、日付、小数など、いくつか種類があります。よく使うものは[Flask-SQLAlchemyのサイト](http://flask-sqlalchemy.pocoo.org/2.3/models/)に、一覧は[SQLAlchemyのサイト](https://docs.sqlalchemy.org/en/latest/core/type_basics.html)にあります。

その下の`__repr__`関数は単に表示を見やすくするためだけに書いています。

細かい説明は後回しにして、さっそく使ってみましょう！

まずは下準備から。

```python
>>> from flask import Flask
>>> app = Flask(__name__)
>>> db.init_app(app)  # 警告が出るけどここでは無視
C:\Users\W\.virtualenvs\backend-T-5B7hGY\lib\site-packages\flask_sqlalchemy\__init__.py:774: UserWarning: Neither SQLALCHEMY_DATABASE_URI nor SQLALCHEMY_BINDS is set. Defaulting SQLALCHEMY_DATABASE_URI to "sqlite:///:memory:".
  'Neither SQLALCHEMY_DATABASE_URI nor SQLALCHEMY_BINDS is set. '
C:\Users\W\.virtualenvs\backend-T-5B7hGY\lib\site-packages\flask_sqlalchemy\__init__.py:794: FSADeprecationWarning: SQLALCHEMY_TRACK_MODIFICATIONS adds significant overhead and will be disabled by default in the future.  Set it to True or False to suppress this warning.
  'SQLALCHEMY_TRACK_MODIFICATIONS adds significant overhead and '
>>> app.app_context().push()
>>> db.create_all()
```

これであなたのデータベースが作成されました。では`Student`のレコードを作成していきます。

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

では、追加されたレコードを見てみましょう。レコードは`Student.query.○○`という操作で参照することができます。

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

いろいろな操作が用意されています。一覧を見たいなら[こちら](https://docs.sqlalchemy.org/en/latest/orm/query.html#sqlalchemy.orm.query.Query)を一応用意しておきます。

さて、ここで`carol`のidがいつの間にか設定されていたことに気づいたでしょうか。

`carol`を初期化した時、`id`は`None`になっていました。

実は、`primary_key=True`とした`id`カラムは、いちいち設定しなくても自動で設定してくれるのです。ただし、`id`の重複は認められません。気になる場合は自分でレコードを作って`commit`で追加しようとしてみてください。

なので、今回の`alice`や`bob`のように`id`を設定することはまずありません。

それから、`primary_key=True`を設定できるカラムもテーブルに一つのみ、必ず必要です。

また、下の例からもわかるように、`id`以外のカラムが自動で設定されることもありません。

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

## 創作展で実際に使ったものをつくってみよう

実際にはより簡略化したものを作ってみます。

以下のように入力してください。
