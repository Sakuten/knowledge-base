# Windows 10 Pro以外でのDockerインストール方法

ちょっと手順が特殊です

1. [Chocolateyをインストール](https://chocolatey.org/install)
2. [VirtualBoxをインストール](https://www.virtualbox.org/wiki/Downloads)
3. [Git for Windowsをインストール](https://gitforwindows.org/)
4. docker-machineをインストール: `choco install docker-machine -y`
5. Powershellで`fsutil behavior set SymlinkEvaluation L2L:1 R2R:1 L2R:1 R2L:1`と実行
6. Git Bashで以下を実行し、仮想マシンを作る

  ```bash
  docker-machine create --driver virtualbox default
  ```

7. Git Bashで以下を実行し、仮想マシンに入る

  ```bash
  docker-machine ssh default -L 8000:localhost:8000 -L 8081:localhost:8081 -L 8888:localhost:8888
  ```

8. (ここから仮想マシン上で)以下のコマンドを実行し、composeをインストールする

  ```bash
  sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname   -m) -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  ```

9. `cd`とだけ打って、Windows側のユーザーディレクトリに移動
10. `devenv`のディレクトリへ`cd`
11. `docker-compose up`
12. 完了。あとはWindows側から更新すれば自動ビルドがかかります

初回以降は7からやればOKです