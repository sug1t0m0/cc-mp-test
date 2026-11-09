# cc-mp-test

Claude Code 開発支援プラグイン集

> [Dev Environment](https://github.com/users/sug1t0m0/projects/5) project の一部。
> 関連 repo / 横断規約 / ADR は umbrella repo [my-dev-protocol](https://github.com/sug1t0m0/my-dev-protocol) を参照。

## Responsibility

Claude Code 開発支援プラグインの公開と配布:

- plugin marketplace 設定 (Claude Code から `add` 可能な配布点)
- AI 駆動開発フローを補助するプラグインの実装と保守

## プラグイン一覧

| プラグイン | 説明 |
|-----------|------|
| **session-summary** | セッションを要約・エクスポート。学びを記録し、どのプロジェクトでも使える。 |
| **workflow-helper** | Git worktreeとWezTermを活用した並列開発ワークフロー支援ツール |
| **dialogue-patterns** | AI エージェントとのやり取りのパターン。一つ目は decisions: 設問を一つずつ番号で出し、スマートフォンで読める形で応え、設問の解説と進捗を artifact に保つ。 |

## インストール

### 1. マーケットプレイスを追加

```bash
/plugin marketplace add sug1t0m0/cc-mp-test
```

### 2. プラグインをインストール

```bash
# 個別にインストール
/plugin install session-summary@cc-mp-test
/plugin install workflow-helper@cc-mp-test
```

dialogue-patterns はリポジトリごとに入れる (`--scope project`)。手順は [plugins/dialogue-patterns/README.md](plugins/dialogue-patterns/README.md)。

## プラグイン詳細

### session-summary

セッションの要約とエクスポート機能を提供します。

**コマンド:**
- `/session-summary:setup` - Global gitignore に .claude-sessions を追加
- `/session-summary:summary` - セッションを要約
- `/session-summary:export` - セッション要約をMarkdownファイルに保存
- `/session-summary:learnings` - セッションから学び（TIL）を抽出

### workflow-helper

Git worktreeとWezTermを活用した並列開発ワークフローを支援します。

**コマンド:**
- `/workflow-helper:new-task [task-name]` - 新しいworktreeを作成し、WezTermで新ペインを開く
- `/workflow-helper:list-tasks` - 現在のworktree一覧を表示
- `/workflow-helper:cleanup-tasks [target]` - 完了したworktreeを削除

### dialogue-patterns

AI エージェントとのやり取りのパターンの入れ物。一つ目のパターン `decisions` は、設問を一つずつ番号で出す決まり、スマートフォンで読める応答の形、設問の解説と進捗を保つ二つの artifact からなる。決まりは plugin にだけ置き、使う側のリポジトリには写さない。経緯は [#3](https://github.com/sug1t0m0/cc-mp-test/issues/3)。

入れ方と更新は [plugins/dialogue-patterns/README.md](plugins/dialogue-patterns/README.md)。

## ライセンス

MIT
