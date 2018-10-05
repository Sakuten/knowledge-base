# Wikiに資料を追加する

## 必要なもの

- `yarn` (`npm`でもいいです)
- `git`

## Getting Started

```bash
git clone https://github.com/Sakuten/knowledge-base.git
cd knowledge-base
yarn install --dev
```

これで環境は構築できました。

下記のコマンドで開発サーバが立ち上がり、レンダリングされたGitBookを見ることができます。

```bash
yarn start
```

## 項目を追加する

新しく項目を追加するには、通常の`backend`や`frontend`と同じように`feature`を切ってPRを出す必要があります。

```bash
git flow feature start your-post
# ..
# 資料を書く
# ..
git push origin feature/your-post
```

PRがマージされると、デプロイされたWikiで追加された項目を見ることができるようになります。お疲れ様でした。


