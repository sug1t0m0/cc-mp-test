# dialogue-patterns

AI エージェントとのやり取りのパターンの入れ物。一つ目のパターン `decisions` は、設問を一つずつ番号で出す決まり、スマートフォンで読める応答の形、設問の解説と進捗を保つ二つの artifact からなる。

[onramp](https://github.com/sug1t0m0/onramp) の開発で使っていた決まりを plugin にしたもの。

## 中身

どのパターンにも共通のもの。

- **決まり** (`glossary.md`、`contract.md`): 語彙と、共通の約束。約束は、決まりは plugin にだけ置く、変えたいことは skill `propose-change` で出す、すべての返事と artifact の頭にヘッダーを書く、CLAUDE.md が食い違ったら言う、の四つ
- **hook** (`hooks/hooks.json`、`hooks/session-start.sh`): セッションの始まり (resume、compact の後も) に、identity の一行と決まり (glossary.md、contract.md、パターンの dialogue.md) を Claude の文脈に流す。identity は `dialogue-patterns · decisions · <コミット SHA>` で、返事の頭の一行目に出る。SHA は cache のフォルダ名 (12 桁) から取り、`--plugin-dir` で読んでいるときは `git rev-parse --short=12 HEAD`、どちらも取れなければ `unknown`
- **skill `propose-change`** (`skills/propose-change/SKILL.md`): 決まりを変えたいときの流れ。下の「決まりを変えたいとき」

パターン `decisions` のもの。

- **進め方** (`patterns/decisions/dialogue.md`): 設問の出し方、説明の仕方、返事の受け取り方、報告、artifact の使い方。ヘッダーの二行目 `設問 N · 見込み M 問 · 決まった K` もここで決める
- **output style `decisions`** (`output-styles/decisions.md`): スマートフォンで読みやすい応答の形。短い文、階層の番号、幅に収まる図と表。`force-for-plugin: true` なので、この plugin が有効なリポジトリでは自動で適用され、settings.json の `outputStyle` に別の style が書いてあっても、この style が優先される (docs の `force-for-plugin` の説明のとおり)。使う側の settings.json に `outputStyle` があれば消してよい
  - 外すには、この plugin を無効にする。`/output-style` で別の style を選んでも、この style が入る
  - ほかの有効な plugin にも `force-for-plugin: true` の style があると、最初に読まれた一つだけが効く
  - Claude Code v2.1.289 では、`/output-style` の表示は settings の値のままで、`default` や別の名前が出ていてもこの style が system prompt に入っている。表示は版で変わりうるので、効いているかは応答の形で見る
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

使う側の CLAUDE.md には、この一文だけ書く。plugin の中身 (パターンの名前、部品の種類や数) は書かない。plugin 側が変わっても使う側の CLAUDE.md が変わらないようにするため。

```markdown
応答の形は、やり取りの plugin に準じる。plugin が読み込まれていなければ、作業を進める前にそのことを言って止まる。
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
- 効いているかは、返事の頭の一行目で見る。`dialogue-patterns · decisions · <SHA>` が出ていれば hook が動いていて、SHA が今の版

## 更新

版は plugin.json に書かない。版はこのディレクトリのコミット SHA で、cache のフォルダ名にもなる。main が進んだら、使う側で打つ。

```bash
claude plugin update dialogue-patterns@cc-mp-test
```

新しい SHA のフォルダが cache にでき、次のセッションの立ち上げから効く。返事の頭の identity の SHA が変わる。

`claude plugin marketplace update cc-mp-test` は marketplace の clone (`~/.claude/plugins/marketplaces/cc-mp-test/`) を進めるだけで、cache は変わらない。clone した人が install を打っていない場合は、この後にセッションを立ち上げ直すと新しい SHA がコピーされる。

自動で追いたいときは、`extraKnownMarketplaces` の項目に `"autoUpdate": true` を足す。

## 手元で試す

このリポジトリを変えながら試すときは、`--plugin-dir` で直接読む。同じ名前の marketplace の plugin を置き換えるので、使う側の settings.json はそのままでよい。

```bash
claude --plugin-dir /path/to/cc-mp-test/plugins/dialogue-patterns
```

マージ前の branch を marketplace 経由で試すには、`claude plugin marketplace add 'sug1t0m0/cc-mp-test#<branch>' --scope project` と打つ。settings.json の source に `"ref"` が足される。試し終わったら、同じコマンドを `#<branch>` なしで打ち直して main に戻す。settings.json から `ref` を消すだけでは `~/.claude/plugins/known_marketplaces.json` に `ref` が残り、更新がその branch を追い続ける。

## 決まりを変えたいとき

決まりは plugin にだけ置く。使う側の CLAUDE.md やメモリに写さない。変えたいことは skill `propose-change` で出す。流れは次のとおり。

1. 変える所と理由を、identity と一緒にまとめる
2. このリポジトリに issue を立てる
3. GitHub の道具が使えれば PR を出す (`Closes #N`)。使えなければ issue まで
4. main に入ったら、使う側で上の更新コマンドを打つ

セッションの中で「次からこうして」と言われたときも、Claude はその場で守りつつ、この流れで plugin に出す。

## 参考

- [Install and manage plugins](https://code.claude.com/docs/en/plugins/install.md)
- [Plugin loading reference](https://code.claude.com/docs/en/plugins/loading.md)
- [Marketplace reference](https://code.claude.com/docs/en/plugins/marketplace-reference.md)
- [Hooks reference](https://code.claude.com/docs/en/hooks.md) (SessionStart の stdout は 10,000 字まで文脈に入る)
