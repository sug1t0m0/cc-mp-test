---
name: new-task
description: 新しいgit worktreeを作成し、WezTermの新しいペインで作業を開始します。タスク名を引数に指定してください。
argument-hint: [task-name]
disable-model-invocation: true
allowed-tools: Bash(git:*), Bash(wezterm:*)
---

# 新しいタスクの開始

ユーザーが新しいタスクを開始したいときに使用します。

## 処理手順

1. `$ARGUMENTS` からタスク名を取得
2. タスク名をブランチ名に変換（小文字化、スペース→ハイフン）
3. git worktreeを作成
4. WezTermで新しいペインを開いてworktreeディレクトリに移動

## 実行するコマンド

以下のコマンドを順番に実行してください：

```bash
# 変数設定
TASK_NAME="$ARGUMENTS"
PROJECT_NAME=$(basename "$(pwd)")
BRANCH_NAME=$(echo "$TASK_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed 's/[^a-z0-9-]//g')
WORKTREE_PATH="../${PROJECT_NAME}-${BRANCH_NAME}"

echo "📦 Creating worktree: $WORKTREE_PATH"
echo "🌿 Branch: $BRANCH_NAME"
```

```bash
# Worktree作成
git worktree add "$WORKTREE_PATH" -b "$BRANCH_NAME"
```

```bash
# WezTermで新しいペインを開く
wezterm cli split-pane --right --percent 50 -- bash -c "cd '$WORKTREE_PATH' && echo '🚀 Worktree ready!' && echo '📍 Path: $WORKTREE_PATH' && echo '🌿 Branch: $BRANCH_NAME' && echo '' && echo 'Run: claude' && exec bash"
```

最後に、作成されたworktreeの情報をユーザーに報告してください。

## タスク名

$ARGUMENTS
