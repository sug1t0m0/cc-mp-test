# dialogue-patterns

AI エージェントとのやり取りのパターンの入れ物。一つ目のパターン `questions` は、設問を一つずつ番号で出す決まり、スマートフォンで読める応答の形、設問の解説と進捗を保つ二つの artifact からなる。

段階的に移している ([sug1t0m0/cc-mp-test#3](https://github.com/sug1t0m0/cc-mp-test/issues/3))。今は空の plugin で、中身はこれから入る。

## 入れ方

リポジトリごとに入れる。使う側のリポジトリのフォルダで二つ打つ。

```bash
claude plugin marketplace add sug1t0m0/cc-mp-test --scope project
claude plugin install dialogue-patterns@cc-mp-test --scope project
```

二つとも、そのリポジトリの `.claude/settings.json` に書く。できたものをコミットする。

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

同じ内容を手で書いても結果は同じ。コマンドで入れると、加えて `~/.claude/plugins/cache/cc-mp-test/dialogue-patterns/<コミット SHA>/` にコピーが置かれ、`~/.claude/plugins/installed_plugins.json` に scope project の記録ができる。この記録があると、下の更新コマンドが使える。

### リポジトリを clone した人

settings.json がコミットされていれば、フォルダを信頼した時点で marketplace が登録され、plugin が読まれる (cache にコピーされるが、install 記録は作られない)。更新コマンドを使えるようにするため、一度だけ打つ。settings.json は変わらない。

```bash
claude plugin install dialogue-patterns@cc-mp-test --scope project
```

### 注意

- Claude Code v2.1.289 で確かめた。古い版で `/plugin` の Errors に `Plugin "dialogue-patterns" is enabled in project settings but isn't installed here` と出たら、上の install を打つか、Claude Code を更新する
- `--scope project` を付けずに `/plugin install` すると、`~/.claude/settings.json` に書かれて全リポジトリで有効になる。付け忘れたら `claude plugin uninstall dialogue-patterns@cc-mp-test` で外し、付けて入れ直す
- 読み込まれているかは `/plugin` の Installed で見る。install 済みなら「Project」の見出しの下に `dialogue-patterns · cc-mp-test` と出る

## 更新

版は plugin.json に書かない。版はこのディレクトリのコミット SHA で、cache のフォルダ名にもなる。main が進んだら、使う側で打つ。

```bash
claude plugin update dialogue-patterns@cc-mp-test
```

新しい SHA のフォルダが cache にでき、次のセッションの立ち上げから効く。

`claude plugin marketplace update cc-mp-test` は marketplace の clone (`~/.claude/plugins/marketplaces/cc-mp-test/`) を進めるだけで、cache は変わらない。clone した人が install を打っていない場合は、この後にセッションを立ち上げ直すと新しい SHA がコピーされる。

自動で追いたいときは、`extraKnownMarketplaces` の項目に `"autoUpdate": true` を足す。

## 手元で試す

このリポジトリを変えながら試すときは、`--plugin-dir` で直接読む。同じ名前の marketplace の plugin を置き換えるので、使う側の settings.json はそのままでよい。

```bash
claude --plugin-dir /path/to/cc-mp-test/plugins/dialogue-patterns
```

マージ前の branch を marketplace 経由で試すには、`claude plugin marketplace add 'sug1t0m0/cc-mp-test#<branch>' --scope project` と打つ。settings.json の source に `"ref"` が足される。試し終わったら、同じコマンドを `#<branch>` なしで打ち直して main に戻す。settings.json から `ref` を消すだけでは `~/.claude/plugins/known_marketplaces.json` に `ref` が残り、更新がその branch を追い続ける。

## 決まりを変えたいとき

段階 3 で skill `propose-change` (仮名) と一緒に書く。流れは、変える所と理由をまとめ、このリポジトリに issue を立て、書けるなら PR を出し、使う側で上の更新コマンドを打つ。

## 参考

- [Install and manage plugins](https://code.claude.com/docs/en/plugins/install.md)
- [Plugin loading reference](https://code.claude.com/docs/en/plugins/loading.md)
- [Marketplace reference](https://code.claude.com/docs/en/plugins/marketplace-reference.md)
