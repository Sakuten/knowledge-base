# Dockerの概念

さてここまで色々やってきたわけだが、ここでは今までやってきたことがどういった操作だったのかについて詳しく説明する。

とりわけ以下のようなDocker特有の概念について、今までやったことと対応づけながら説明していく。

- イメージ(image)
- コンテナ(container)
- レジストリ(registry)

## イメージ(image)

イメージとは、今までこの記事で「環境」と呼んでいたものそのものだ。
ソフトウェアを動作させるために必要なファイル群をまとめたもの、とも言える。
なお一般的にイメージというと色々な意味があるので、「Dockerイメージ」と呼ばれることが多い。

最初に`docker run`を実行した時、なんだかダウンロードが始まったと思うが、あれはイメージをダウンロードしている。
イメージはソフトウェアを実行するために必要なものを全て同梱しているため、容量が大きくなることが多い。(とはいえ普通は1GBを超えない程度だ)

全てのイメージには一意なIDが振られている。イメージを変更することはできず(read only)、変更を加えるときは別のIDを持ったイメージを再度作成することになる。(gitのコミットハッシュをイメージしてほしい)

また、IDに対して"タグ"をつけることができる。これは特定のIDにわかりやすく目印をつけるためのものである。(gitのタグと同じようなもの)

### イメージを作ってみる

イメージは`Dockerfile`という名前のファイルから、`docker image build`コマンドで作成することができる。

{% hint style='info' %}
わかりやすさのために`docker image build`を使用しているが、[`docker build`](https://docs.docker.com/engine/reference/commandline/build/)と同義である。
{% endhint %}

`Dockerfile`はいわば"イメージの設計図"で、そこにはどうやってイメージを作成するか、指示を書いていく。

ここでは例として、「[`cowsay`というジョークプログラム](https://ja.wikipedia.org/wiki/Cowsay)を実行して牛の絵を表示するDockerイメージ」を作ってみる。

結論からいうとこんな感じだ。

```dockerfile
FROM ubuntu:18.10

RUN apt-get update -y
RUN apt-get install -y cowsay

CMD ["/usr/games/cowsay", "This is working!"]
```

一行づつ説明していく。

#### `FROM`コマンド

これは、これからイメージを組み立てていく上で「既存のイメージをベースにするよ」というコマンドだ。
ここでは`ubuntu:18.10`と書いてある。これは「`ubuntu`イメージの`18.10`というタグを使う」という意味だ。

#### `RUN`コマンド

このコマンドに渡した文字列(ここでは`apt-get update -y`など)は、コマンドと解釈され、構築中のイメージの中で実行される[^1]。

ubuntuユーザーにとってはおなじみのコマンドで、`cowsay`をインストールしているのがわかると思う。

{% hint style='tip' %}
コマンドは`/bin/sh`で走るので、`&&`や`>`などは動く。
{% endhint %}

[^1]: 正確にはビルド時に生成される一時コンテナの中で実行される

#### `CMD`コマンド

`CMD`では、イメージが実行される時に[^2]実行するコマンドを指定する。

ここでは`/usr/games/cowsay`というプログラムに、`This is working!`という文字列を渡している。すなわちcowsayで「This is working!」と表示するコマンドというわけだ。

{% hint style='tip' %}
ご覧の通り配列形式で指定しているが、実はこれは下のように書いても動く。

```dockerfile
CMD /usr/bin/cowsay "This is working!"
```

だが、配列形式ではなくシェル形式(上の書き方)で書いた場合`/bin/sh`を経由して実行することになる。さらに引数の明示性の観点からも、`CMD`では配列形式が好まれる。
{% endhint %}

[^1]: 正確にはイメージから生成されたコンテナが実行される時

#### イメージをビルドする

というわけで、イメージをビルドしよう。

`Dockerfile`が存在するディレクトリで、以下のコマンドを実行する。

```shell
$ docker image build . -t example-image
<色々ログが流れる>
Successfully tagged example-image:latest
```

[docker image build | Docker documentation](https://docs.docker.com/engine/reference/commandline/image_build/)

これでイメージが生成できた。

なおここでは`-t`で名前として`example-image`を指定しているため、以降このイメージは`example-image`として参照できることになる。

実際にイメージが生成できているのか確認してみよう。

```shell
$ docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
example-image       latest              f839d43061a3        38 minutes ago      138MB
```

[docker image ls | Docker documentation](https://docs.docker.com/engine/reference/commandline/image_ls/)

{% hint style='info' %}
わかりやすさのために`docker image ls`を使用しているが、[`docker images`](https://docs.docker.com/engine/reference/commandline/images/)と同義である。
{% endhint %}

このように、先ほど生成したイメージの情報が表示される。なおタグはデフォルトで`latest`になっている。

次はもう一つの重要な概念、"コンテナ"について説明する。

## コンテナ(container)

コンテナは、実際にDockerを使ってソフトウェアを実行する際に作られる隔離環境のことだ。
コンテナの中からはコンテナは独立したシステムであるように見える。実際コンテナはホストのシステムとはある程度隔離されており、例えば

- ディレクトリ
  - 例: ルート`/`が独立して存在している
- プロセス
  - 例: PID0 (init)が独立して存在している
- ユーザー
  - 例: ルートユーザー`root`が独立して存在している

がホストから独立している。(他にも色々あるので気になる人は"linux namespace"や"cgroups"で検索)

これにより、(基本的に)コンテナ内部から外のシステムにはアクセスできないようになっている。(そもそも内部からは外の存在すらわからない)

また、コンテナは揮発性を持つと言える。コンテナの中でファイルを変更することはできるが、コンテナの削除の際にその変更はなかったことになる。永続化するには、後述する方法でイメージにするしかない。

コンテナは2つの状態を持っている。「実行中」と「停止中」だ。

### コンテナを作成/実行してみる

コンテナはイメージから作成する。
ここでは先ほど作成した`example-image`からコンテナを作ってみる。次のコマンドを実行してみよう。

```shell
$ docker container create exmaple-image
<コンテナIDが出力される>
```

[docker container create | Docker documentation](https://docs.docker.com/engine/reference/commandline/container_create/)

{% hint style='info' %}
わかりやすさのために`docker container create`を使用しているが、[`docker create`](https://docs.docker.com/engine/reference/commandline/create/)と同義である。
{% endhint %}

これで`example-image`からコンテナを作成できた。

`0fa275c5b6c0c983de67dfb4c2ea91fd8ec38365a9c9a99ae28307aefe189386`のような文字列が出力されたと思う。これが作成されたコンテナの"コンテナID"だ。

実際に作成できたのかどうか、以下のコマンドで確かめよう。

```shell
$ docker container ls --all
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                  NAMES
0fa275c5b6c0        example-image       "/usr/games/cowsay '…"   18 seconds ago       Created                                    dreamy_bardeen
```

[docker container ls | Docker documentation](https://docs.docker.com/engine/reference/commandline/container_ls/)

{% hint style='info' %}
わかりやすさのために`docker container ls`を使用しているが、[`docker ps`](https://docs.docker.com/engine/reference/commandline/ps/)と同義である。
{% endhint %}

{% hint style='tip' %}
`NAMES`に書いてある文字列(ここでは`dreamy_bardeen`)は、コンテナの"名前"である。コンテナIDは覚えにくい(それはそう!)ため、覚えやすい名前がコンテナ作成時に自動的に付与される。
名前はコンテナIDの代わりに使うことができる。コンテナ作成時に自分で名前をつけることもできる。(`--name`オプション)
{% endhint %}

では作成したコンテナを実行しよう。

```shell
$ docker container start --attach <コンテナID/名前>
 __________________
< This is working! >
 ------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

このようにイメージ作成時に`CMD`に指定したコマンドが実行されたことが確認できると思う。

## イメージとコンテナの関係

このようにコンテナはイメージから作るわけだが、実はイメージはコンテナから作ることもできる。[^3]

[^3]: 注意深くログを見ればわかるが、`docker image build`も、結局は一時コンテナを作ってイメージを再生成しているのだ

とはいえ手動でコンテナからイメージを作ることはほとんどないので、とりあえず現時点では

- イメージ: 永続的で不変な環境。配布できる。ファイルのようなもの
- コンテナ: 揮発的な環境。実行できる。プロセスとメモリのようなもの

と思ってもらえればOKだ。

### `docker run`

前々から出てきている`docker run`コマンド、これは「イメージからコンテナを作成し、それを実行」ということをやっている。

すなわち`docker container create`と`docker container start`を一緒にやってくれている。便利なのでよく使われる。

## レジストリ (registry)

レジストリは、Dockerイメージを保持し、共有するシステムだ。
一般的にインターネット上にサービスとして存在し、そこと通信することで利用する。

今まで使ってきた`nginx`や`ubuntu`のイメージは全てレジストリ上にあり、そこから取得していたのだ。(だからダウンロードが必要だった)

デフォルトのレジストリは[Docker Hub](https://hub.docker.com/)であり、特に指定しない場合はここが使われる。
他にも[quay.io](https://quay.io/)のようなレジストリサービスが存在しているほか、自分でレジストリを立てることもできる。

`docker image push`、`docker image pull`でそれぞれレジストリにイメージをアップロード、ダウンロードできるが、ここでは扱わない。詳しくは参考文献を参照してほしい。
