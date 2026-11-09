# dialogue-patterns の開発

この plugin を直す人向け。使う人向けの説明は README.md にある。決まりの本文は glossary.md、contract.md、patterns/ にあり、ここには写さない。

## 構造

```
.claude-plugin/plugin.json      name と description。version は書かない
glossary.md                     共通の語彙
contract.md                     共通の約束
hooks/hooks.json                SessionStart → session-start.sh
hooks/session-start.sh          identity を作り、glossary、contract、dialogue.md を流す
patterns/<パターン>/dialogue.md  パターンの進め方
output-styles/<パターン>.md      パターンの応答の形 (force-for-plugin: true)
skills/<skill>/SKILL.md         パターンを支える skill と、共通の skill
README.md                       使う人向け
CLAUDE.md                       このファイル
```

## 共通とパターンの分け方
- 共通: どのパターンでも同じもの。語彙 (glossary.md)、約束 (contract.md)、identity を作って決まりを流す hook、決まりを変える流れ (skill `propose-change`)
- パターン: 進め方 (`patterns/<名前>/dialogue.md`)、応答の形 (`output-styles/<名前>.md`)、それを支える skill。今あるのは `decisions` (進め方、output style `decisions`、skill `decision-artifacts`)
- 迷ったら、二つ目のパターンでも同じ文になるかで分ける。同じならば共通、変わるならばパターン
- ヘッダーの一行目 (identity) は共通、二行目以降はパターンが決める

## 決まりの書き方
- 決まりは個別の場面に寄せずに書く。場面ごとの但し書きを足さない。足したくなったら、決まりそのものを言い直す
- 必要条件で書く (これは保つ)。十分条件 (これ以外はしない) にしない。使う側が自分の都合で足せる余地を残す
- 文は短く、一文に一つのこと。日本語で書く
- 使う側の CLAUDE.md には plugin の中身を書かせない。README の「入れ方」にある一文だけ

## hook
- SessionStart の標準出力は Claude の文脈に入る (10,000 字まで。超えるとファイルに落ちて先頭 2,000 字しか見えない)。今は 3,000 字ほど。決まりを足すときは `CLAUDE_PLUGIN_ROOT=$PWD ./hooks/session-start.sh | wc -m` で確かめる
- matcher を書いていないので、startup、resume、clear、compact、fork のどれでも動く
- `CLAUDE_PLUGIN_ROOT` は install 済みなら `~/.claude/plugins/cache/cc-mp-test/dialogue-patterns/<SHA>/`、`--plugin-dir` ならそのディレクトリ。SHA の三段 (フォルダ名、git、unknown) はスクリプトのコメントにある
- 手元で試す: `CLAUDE_PLUGIN_ROOT=$PWD ./hooks/session-start.sh`

## 版
- plugin.json に `version` を書かない。版はこのディレクトリのコミット SHA (12 桁) で、cache のフォルダ名と identity の三つ目になる
- 使う側は `claude plugin update dialogue-patterns@cc-mp-test` で追う

## 試し方
- `claude plugin validate plugins/dialogue-patterns` (リポジトリの root で)
- `claude --plugin-dir /path/to/cc-mp-test/plugins/dialogue-patterns` で立ち上げ、返事の一行目に identity が出ること、応答の形が output style のとおりになることを見る
- output style が効いているかは `/output-style` の表示では分からない (settings の値を映す)。system prompt の見出し `# Output Style: dialogue-patterns:decisions` を Claude に引用させるか、応答の形で見る

## 二つ目のパターンを足すとき
- `patterns/<名前>/dialogue.md`、`output-styles/<名前>.md`、必要な skill を足す
- 決めること: `force-for-plugin: true` の output style は最初に読まれた一つしか効かないので、パターンの選び方 (settings か、環境変数か、別の plugin に分けるか) と、hook がどのパターンを流すか。今の hook は `pattern="decisions"` を固定で持つ
