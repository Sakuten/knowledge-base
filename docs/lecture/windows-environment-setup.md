# Windows 10 Pro以外でのDockerインストール方法

ちょっと手順が特殊です。

1. [Chocolateyをインストール](https://chocolatey.org/install)
2. [VirtualBoxをインストール](https://www.virtualbox.org/wiki/Downloads)
3. [Git for Windowsをインストール](https://gitforwindows.org/)
4. docker-machineをインストール: `choco install docker-machine -y`
5. Powershellで`fsutil behavior set SymlinkEvaluation L2L:1 R2R:1 L2R:1 R2L:1`と実行
6. コマンドプロンプト、PowerShell、Git Bashのいずれかで以下を実行し、仮想マシンを作る

    ```bash
    docker-machine create --driver virtualbox default
    ```

7. 以下を実行し、仮想マシンに入る

    ```bash
    docker-machine ssh default -L 8000:localhost:8000 -L 8081:localhost:8081 -L 8888:localhost:8888
    ```

8. （ここから仮想マシン上で）以下のコマンドを実行し、docker-composeをインストールする

    ```bash
    sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$  (uname   -m) -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    ```

9.  `devenv`のディレクトリへ`cd`
    ※Cドライブが`/c/`にマウントされているので、パスは`/c/Users/〇〇/...`のようになるでしょう。
10. `docker-compose up`
11. 完了。あとはWindows側から更新すれば自動ビルドがかかります

<!-- textlint-disable no-dead-link -->

うまく行っていれば、ブラウザで[http://localhost:8000/](http://localhost:8000/)を開くと、創作展のWeb抽選システムのトップページが表示されます。

<!-- textlint-enable no-dead-link -->

## 注意・補足

* 次回以降は手順6の代わりに`docker-machine start default`とし、7から始めましょう。
* 手順10で`docker-compose up -d`とすると、バックグラウンドでdockerを走らせることができます。

<!-- textlint-disable ja-technical-writing/no-doubled-joshi -->

* `devenv/scripts`以下のスクリプトは、手順7で開いた仮想マシン上で実行してください。

<!-- textlint-enable ja-technical-writing/no-doubled-joshi -->

* docker-machineに接続しているコマンドプロンプトを閉じてもVirtualBoxは動いています。
  なので、シャットダウンするときに「VirtualBoxがシャットダウンを妨げている」というような画面が出てくるでしょう。
  無視して強制的にシャットダウンしても問題はないのですが、気になるようであれば、
  コマンドプロンプトで`docker-machine stop default`としましょう。
