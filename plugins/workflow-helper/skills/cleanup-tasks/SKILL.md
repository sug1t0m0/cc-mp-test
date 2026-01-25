---
name: cleanup-tasks
description: 完了したgit worktreeを削除します。引数なしで一覧表示、引数ありで指定したworktreeを削除します。
argument-hint: [worktree-path or branch-name]
disable-model-invocation: true
allowed-tools: Bash(git:*)
---

# Worktreeのクリーンアップ

完了したタスクのworktreeを削除します。

## 処理フロー

### 引数なしの場合

現在のworktree一覧を表示し、削除対象を確認します：

```bash
echo "📋 現在のWorktrees:"
echo ""
git worktree list
echo ""
echo "削除するには: /cleanup-tasks [path or branch-name]"
```

### 引数ありの場合

指定されたworktreeを削除します：

```bash
TARGET="$ARGUMENTS"

# パスで指定された場合
if [[ -d "$TARGET" ]]; then
    git worktree remove "$TARGET"
    echo "✅ Removed worktree: $TARGET"
# ブランチ名で指定された場合
else
    # worktree listから該当パスを検索
    WORKTREE_PATH=$(git worktree list | grep "$TARGET" | awk '{print $1}')
    if [[ -n "$WORKTREE_PATH" ]]; then
        git worktree remove "$WORKTREE_PATH"
        echo "✅ Removed worktree: $WORKTREE_PATH"
    else
        echo "❌ Worktree not found: $TARGET"
    fi
fi
```

## 注意事項

- 未コミットの変更がある場合は `--force` オプションが必要になる場合があります
- メインのworktree（元のリポジトリ）は削除できません
- 削除後、不要になったブランチは別途 `git branch -d` で削除できます

## 対象

$ARGUMENTS
