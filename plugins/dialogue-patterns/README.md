# dialogue-patterns

AI エージェントとのやり取りのパターンの入れ物。一つ目のパターン `questions` は、設問を一つずつ番号で出す決まり、スマートフォンで読める応答の形、設問の解説と進捗を保つ二つの artifact からなる。

段階的に移している (sug1t0m0/cc-mp-test#3)。今は空の plugin で、中身はこれから入る。

## 入れ方

使う側のリポジトリの `.claude/settings.json` に marketplace と plugin を書く。

```json
{
  "extraKnownMarketplaces": {
    "cc-mp-test": {
      "source": {
        "source": "github",
        "repo": "sug1t0m0/cc-mp-test"
      }
    }
  },
  "enabledPlugins": {
    "dialogue-patterns@cc-mp-test": true
  }
}
```

これをコミットしておけば、フォルダを信頼した machine では install の操作は要らない。この plugin は marketplace の中の相対パス (`./plugins/dialogue-patterns`) なので、Claude Code は marketplace の clone (`~/.claude/plugins/marketplaces/cc-mp-test/`) からその場で読む。`~/.claude/plugins/installed_plugins.json` に記録は作られない。

初めてフォルダを開くとき、Claude Code は信頼の確認を出す。信頼すると marketplace を clone し、plugin が読まれる。

## 更新

版は plugin.json に書かない。版はこのディレクトリのコミット SHA。main が進んだら、使う側で marketplace の clone を更新する。

```bash
claude plugin marketplace update cc-mp-test
```

更新は次のセッションの立ち上げ、または `/reload-plugins` で効く。

`claude plugin update dialogue-patterns@cc-mp-test` は使わない。これは cache に入れた plugin を更新するコマンドで、相対パスの plugin には install 記録がない。

自動で追いたいときは、`extraKnownMarketplaces` の項目に `"autoUpdate": true` を足す。

## 手元で試す

このリポジトリを変えながら試すときは、clone を更新せずに `--plugin-dir` で直接読む。

```bash
claude --plugin-dir /path/to/cc-mp-test/plugins/dialogue-patterns
```

## 決まりを変えたいとき

段階 3 で skill `propose-change` (仮名) と一緒に書く。流れは、変える所と理由をまとめ、このリポジトリに issue を立て、書けるなら PR を出し、使う側で上の更新コマンドを打つ。

## 参考

- [Plugin loading reference](https://code.claude.com/docs/en/plugins/loading.md)
- [Marketplace reference](https://code.claude.com/docs/en/plugins/marketplace-reference.md)
