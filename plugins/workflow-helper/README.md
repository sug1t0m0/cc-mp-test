# workflow-helper

Git worktreeとWezTermを活用した並列開発ワークフロー支援プラグイン。

## 概要

Claude Codeで複数のタスクを並列で処理する際に、git worktreeとWezTermを組み合わせて効率的なワークフローを実現します。

## インストール

```bash
# マーケットプレイスから（設定後）
/plugin install workflow-helper

# または直接指定
claude --plugin-dir /path/to/workflow-helper
```

## コマンド

### `/workflow-helper:new-task [task-name]`

新しいgit worktreeを作成し、WezTermの新しいペインで作業を開始します。

```
/workflow-helper:new-task fix-login-bug
/workflow-helper:new-task feature-user-auth
/workflow-helper:new-task review-pr-123
```

**動作:**
1. タスク名からブランチ名を生成（小文字化、スペース→ハイフン）
2. `../project-name-branch/` にworktreeを作成
3. WezTermで右側に新しいペインを開く
4. 新しいペインでworktreeディレクトリに移動

### `/workflow-helper:list-tasks`

現在のworktree一覧を表示します。

### `/workflow-helper:cleanup-tasks [target]`

完了したworktreeを削除します。

- 引数なし: worktree一覧を表示
- 引数あり: 指定したworktree（パスまたはブランチ名）を削除

## ユーティリティスクリプト

`scripts/worktree-utils.sh` を直接使用することもできます：

```bash
./scripts/worktree-utils.sh new my-feature     # worktree作成
./scripts/worktree-utils.sh open-pane ./path   # ペインを開く
./scripts/worktree-utils.sh list               # 一覧表示
./scripts/worktree-utils.sh remove my-feature  # 削除
./scripts/worktree-utils.sh prune              # 古いworktreeを整理
```

## 要件

- Git
- WezTerm（`wezterm cli` コマンドが利用可能であること）

## ワークフロー例

1. 新しいタスクを開始
   ```
   /workflow-helper:new-task implement-oauth
   ```

2. WezTermの右側に新しいペインが開く

3. 新しいペインで `claude` を実行して独立したセッションを開始

4. タスク完了後、worktreeを削除
   ```
   /workflow-helper:cleanup-tasks implement-oauth
   ```

## ライセンス

MIT
