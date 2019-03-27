# Windowsでの開発方法

## 大まかな流れ

主に必要なプログラムはDockerとGitです。
それぞれどのようなものかざっくりと説明すると、

* Dockerは共通の開発用マシン（コンテナ）をそれぞれのPCで構築できるプログラム
* Gitは複数人でプログラムを書くときに特に有用なバージョン管理ツール

となります。詳しい説明はネット上にたくさんあるので、ググってみてください。

これらをインストールした上で、以下の流れで開発をします。

1. Dockerのコンテナを立ち上げる
2. Gitで管理しながらプログラムを書く
3. devenvの`scripts/`ディレクトリにあるスクリプトで、Dockerを通しテスト等を行う
4. push、PR作成

ここからは、それぞれについてOSごとに解説します。

## 手順0：DockerとGitのインストール

* Windows 10 Pro、Enterprise、Education
  [Docker Desktop for Windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows)と、[Git for Windows](https://gitforwindows.org/)をインストールします。
* その他のWindows
  Docker Desktopが動作しないので、[Docker Toolbox](https://docs.docker.com/toolbox/overview/)というプログラムを利用し、VirtualBoxの中でDockerを走らせることにします。
  Gitは同梱されています。

## 手順1：Dockerのコンテナを立ち上げる

まず最初に、開発環境が含まれるdevnevリポジトリをクローンします（Gitの解説はこの記事では行いません）。

```powershell
> git clone https://github.com/SakutenDev/devenv --recursive
```

ここからDockerを起動します。

* Windows 10 Pro、Enterprise、Education
  devenvディレクトリに移動して、`.\scripts\start.ps1`を実行すればOKです（※）。
* その他のWindows
  Docker Toolboxをインストールした時に、Docker Quickstart Terminalというリンクがデスクトップとスタートメニューに追加されています。
  これを**右クリックして「管理者として実行」をクリック**します。
  これによってVirtualBoxがバックグラウンドで立ち上がるので、しばらくしてクジラのアスキーアートが出てくることを確認したら、閉じて構いません。
  このあとはdevenvディレクトリで、`.\scripts\start.ps1`を実行してください（※）。

※初回はDockerコンテナのビルドが行われるため、時間がかかり、エラーも発生するかもしれないので、以下の手順を踏むことをおすすめします。

```powershell
> .\scripts\build.ps1
> docker-compose up
```

<!-- textlint-disable no-dead-link -->

上記の作業がうまくいっていれば、ブラウザで[http://localhost:8000](http://localhost:8000)を開くと、創作展Web抽選システムのトップページが表示されるはずです。
※Docker Toolboxを利用した場合は[http://192.168.99.100:8000/](http://192.168.99.100:8000/)が開きます。

<!-- textlint-enable no-dead-link -->

## 手順2：Gitで管理しながらプログラムを書く

実際に動かすプログラムは、フロントエンドなら`devenv/frontend`、バックエンドなら`devenv/backend`のディレクトリでGitにより管理されています。各ディレクトリで、以下の流れで開発を行います。

Gitの解説はここでは行わないので、わからない単語は適宜Discordで聞くか、Googleで調べてください。

初回は以下のコマンドを実行してから開始してください。
GitHubアカウントの作成も忘れずに。

```powershell
> git checkout develop
> git pull origin develop
> git flow init -d
```

1. GitHubに上がっているIssueの中から自分が担当するものを決め、自分をassignします。
2. `git flow feature start xxx-some-feature-name`と入力します。`xxx-...`となっている部分は、何の変更かわかるように名前をつけてください。
3. ひとまとまりの作業（１ファイル・１挙動の追加・編集）ごとにコミットします。

## 手順3：Dockerを通しテスト等を行う

機能の追加・変更を行うたび、そのためのテストを作り、正しく動作するか確かめましょう。

テストプログラムに、他のテストの書き方にならってテストを追加します。テスト関連のファイルは、フロントエンドは`src/`内の`__test__`、バックエンドは`test/`ディレクトリにあります。わからないことがあれば、手っ取り早く他の開発者に質問するか、テストを書いてもらうのもありでしょう。

テストは、`devenv/`ディレクトリに移動してから、以下のコマンドで行います。

 ```powershell
 > .\scripts\unit_test.ps1 [frontend|backend]
 ```

テストがすべて通る状態になったら、最後の手順に移ります。

## 手順4：push、PR作成

`git push origin feature/xxx-some-feature-name`として、GitHubリポジトリにpushします。

この状態でGitHubのページを開き、PR（プルリクエスト）を作成してください。

書き方は見ればわかると思います。

このPRがmoderatorの人たちにapprove（認証）されると、書いたプログラムは採用され、作業はおしまいです。

お疲れ様でした。

## Docker Toolboxを使った場合の補足

* Docker Quickstart Terminalでも、PowerShellの代わりとして、
  Gitや`scripts/`以下のスクリプトを走らせることができます。
* バックグラウンドでVirtualBoxが走り続けているため、
  シャットダウンするときに「VirtualBoxがシャットダウンを妨げている」というような画面が出てくるでしょう。
  無視して強制的にシャットダウンしても問題はないのですが、気になるようであれば、
  `docker-machine stop default`を実行しましょう。
