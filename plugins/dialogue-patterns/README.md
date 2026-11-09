# dialogue-patterns

AI エージェントとのやり取りのパターン。パターン `decisions` は、設問を一つずつ番号で出す決まり、スマートフォンで読める応答の形、設問の解説と進捗を保つ二つの artifact からなる。

## 中身

どのパターンにも共通のもの。

- **決まり** (`glossary.md`、`contract.md`): 語彙と、共通の約束。約束は、決まりは plugin にだけ置く、変えたいことは skill `propose-change` で出す、すべての返事と artifact の頭にヘッダーを書く、CLAUDE.md が食い違ったら言う、の四つ
- **hook** (`hooks/hooks.json`、`hooks/session-start.sh`): セッションの始まり (resume、compact の後も) に、identity の一行と決まり (glossary.md、contract.md、パターンの dialogue.md) を Claude の文脈に流す。identity は `dialogue-patterns · decisions · <コミット SHA>` で、返事の頭の一行目に出る。この SHA が plugin の版
- **skill `propose-change`** (`skills/propose-change/SKILL.md`): 決まりを変えたいときの流れ。下の「決まりを変えたいとき」

パターン `decisions` のもの。

- **進め方** (`patterns/decisions/dialogue.md`): 設問の出し方、説明の仕方、返事の受け取り方、報告、artifact の使い方。ヘッダーの二行目 `設問 N · 見込み M 問 · 決まった K` もここで決める
- **output style `decisions`** (`output-styles/decisions.md`): スマートフォンで読みやすい応答の形。短い文、階層の番号、幅に収まる図と表。`force-for-plugin: true` なので、この plugin が有効なリポジトリでは自動で適用され、settings.json の `outputStyle` に別の style が書いてあっても、この style が優先される
  - 外すには、この plugin を無効にする。`/output-style` で別の style を選んでも、この style が入る
  - ほかの有効な plugin にも `force-for-plugin: true` の style があると、最初に読まれた一つだけが効く
- **skill `decision-artifacts`** (`skills/decision-artifacts/SKILL.md`): 設問を出すセッションで、今の設問の解説とセッションの進捗の二つの artifact を保つ

## 入れ方

リポジトリごとに入れる。使う側のリポジトリのフォルダで二つ打つ。

```bash
claude plugin marketplace add sug1t0m0/cc-mp-test --scope project
claude plugin install dialogue-patterns@cc-mp-test --scope project
```

二つとも、そのリポジトリの `.claude/settings.json` に書く。できたものをコミットする。settings.json に `outputStyle` があれば消す。

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

使う側の CLAUDE.md には、この二文だけ書く。plugin の中身 (パターンの名前、部品の種類や数) は書かない。

```markdown
応答の形は、やり取りの plugin に準じる。plugin が読み込まれていなければ、作業を進める前にそのことを言って止まる。
```

同じ内容を手で書いても動くが、コマンドで入れると下の更新コマンドが使える。

### リポジトリを clone した人

settings.json がコミットされていれば、フォルダを信頼した時点で plugin が読まれる。更新コマンドを使えるようにするため、一度だけ打つ。settings.json は変わらない。

```bash
claude plugin install dialogue-patterns@cc-mp-test --scope project
```

### 注意

- `/plugin` の Errors に `Plugin "dialogue-patterns" is enabled in project settings but isn't installed here` と出たら、上の install を打つ。それでも出るなら Claude Code を更新する
- `--scope project` を付けずに `/plugin install` すると、`~/.claude/settings.json` に書かれて全リポジトリで有効になる。付け忘れたら `claude plugin uninstall dialogue-patterns@cc-mp-test` で外し、付けて入れ直す
- 読み込まれているかは `/plugin` の Installed で見る。install 済みなら「Project」の見出しの下に `dialogue-patterns · cc-mp-test` と出る
- 効いているかは、返事の頭の一行目で見る。`dialogue-patterns · decisions · <SHA>` が出ていれば hook が動いていて、SHA が今の版

## 更新

版はこのディレクトリのコミット SHA。main が進んだら、使う側で打つ。

```bash
claude plugin update dialogue-patterns@cc-mp-test
```

次のセッションの立ち上げから効く。返事の頭の identity の SHA が変わる。

自動で追いたいときは、`extraKnownMarketplaces` の項目に `"autoUpdate": true` を足す。

## 決まりを変えたいとき

決まりは plugin にだけ置く。使う側の CLAUDE.md やメモリに写さない。変えたいことは skill `propose-change` で出す。流れは次のとおり。

1. 変える所と理由を、identity と一緒にまとめる
2. ユーザーが出すと決めたら、このリポジトリに issue を立てる
3. 頼まれたら PR を出す (`Closes #N`)。GitHub の道具が使えなければ issue まで
4. main に入ったら、使う側で上の更新コマンドを打つ

セッションの中で「次からこうして」と言われたときも、Claude はその場で守りつつ、この流れで plugin に出す。

## 参考

- [Install and manage plugins](https://code.claude.com/docs/en/plugins/install.md)
- [Plugin loading reference](https://code.claude.com/docs/en/plugins/loading.md)
- [Marketplace reference](https://code.claude.com/docs/en/plugins/marketplace-reference.md)
