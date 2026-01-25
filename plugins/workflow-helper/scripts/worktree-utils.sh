#!/bin/bash
# Worktree管理ユーティリティ
# Usage: worktree-utils.sh <command> [args...]

set -e

PROJECT_NAME=$(basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)")

# タスク名をブランチ名に変換
normalize_branch_name() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed 's/[^a-z0-9-]//g'
}

# 新しいworktreeを作成
cmd_new() {
    local task_name="$1"
    if [[ -z "$task_name" ]]; then
        echo "Usage: $0 new <task-name>"
        exit 1
    fi

    local branch_name=$(normalize_branch_name "$task_name")
    local worktree_path="../${PROJECT_NAME}-${branch_name}"

    echo "📦 Creating worktree..."
    echo "   Path: $worktree_path"
    echo "   Branch: $branch_name"

    git worktree add "$worktree_path" -b "$branch_name"

    echo ""
    echo "✅ Worktree created successfully!"
    echo "$worktree_path"
}

# WezTermで新しいペインを開く
cmd_open_pane() {
    local worktree_path="$1"
    if [[ -z "$worktree_path" ]]; then
        echo "Usage: $0 open-pane <worktree-path>"
        exit 1
    fi

    local abs_path=$(cd "$worktree_path" && pwd)
    local branch_name=$(cd "$abs_path" && git branch --show-current)

    wezterm cli split-pane --right --percent 50 -- bash -c "
        cd '$abs_path'
        echo '🚀 Worktree ready!'
        echo '📍 Path: $abs_path'
        echo '🌿 Branch: $branch_name'
        echo ''
        echo 'Run: claude'
        exec bash
    "

    echo "✅ New pane opened for: $worktree_path"
}

# worktree一覧を表示
cmd_list() {
    echo "📋 Git Worktrees for: $PROJECT_NAME"
    echo ""
    git worktree list --porcelain | while read -r line; do
        case "$line" in
            worktree\ *)
                path="${line#worktree }"
                ;;
            HEAD\ *)
                head="${line#HEAD }"
                ;;
            branch\ *)
                branch="${line#branch refs/heads/}"
                printf "  📁 %-40s 🌿 %s\n" "$path" "$branch"
                ;;
        esac
    done
}

# worktreeを削除
cmd_remove() {
    local target="$1"
    if [[ -z "$target" ]]; then
        echo "Usage: $0 remove <worktree-path or branch-name>"
        exit 1
    fi

    if [[ -d "$target" ]]; then
        git worktree remove "$target"
        echo "✅ Removed: $target"
    else
        local worktree_path=$(git worktree list | grep "$target" | awk '{print $1}')
        if [[ -n "$worktree_path" ]]; then
            git worktree remove "$worktree_path"
            echo "✅ Removed: $worktree_path"
        else
            echo "❌ Not found: $target"
            exit 1
        fi
    fi
}

# 古いworktreeを整理
cmd_prune() {
    echo "🧹 Pruning stale worktrees..."
    git worktree prune -v
    echo "✅ Done"
}

# メイン
case "${1:-}" in
    new)
        shift
        cmd_new "$@"
        ;;
    open-pane)
        shift
        cmd_open_pane "$@"
        ;;
    list)
        cmd_list
        ;;
    remove)
        shift
        cmd_remove "$@"
        ;;
    prune)
        cmd_prune
        ;;
    *)
        echo "Worktree Utilities"
        echo ""
        echo "Commands:"
        echo "  new <task-name>      Create new worktree"
        echo "  open-pane <path>     Open worktree in new WezTerm pane"
        echo "  list                 List all worktrees"
        echo "  remove <target>      Remove worktree"
        echo "  prune                Clean up stale worktrees"
        ;;
esac
