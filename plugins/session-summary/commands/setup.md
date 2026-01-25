---
description: Global gitignore に .claude-sessions を追加
allowed-tools: Bash(git config:*), Bash(grep:*), Bash(cat:*), Bash(mkdir:*), Bash(touch:*), Write
---

# セットアップ

ユーザーの global gitignore に `.claude-sessions` を追加します。
これにより、全プロジェクトでセッションログが自動的に Git の追跡対象外になります。

## 手順

### 1. 現在の global gitignore 設定を確認

```bash
git config --global core.excludesFile
```

- 設定がある場合 → そのファイルを使用
- 設定がない場合 → Git のデフォルト `~/.config/git/ignore` を使用

### 2. ファイルの準備

- ディレクトリが存在しない場合は作成 (`mkdir -p`)
- ファイルが存在しない場合は作成 (`touch`)

### 3. 重複チェック

```bash
grep -q "^\.claude-sessions$" [gitignore-file]
```

- すでに `.claude-sessions` が含まれていれば「設定済みです」と報告して終了

### 4. 追加

含まれていなければ `.claude-sessions` を追記

### 5. core.excludesFile の設定（必要な場合）

`~/.config/git/ignore` を使用し、かつ `core.excludesFile` が未設定の場合は設定する:

```bash
git config --global core.excludesFile ~/.config/git/ignore
```

## 報告内容

完了後、以下を報告してください：

✅ **設定完了の場合**:
```
✅ Global gitignore に .claude-sessions を追加しました。
   ファイル: [使用したパス]
   これで全プロジェクトで .claude-sessions/ が自動的に ignore されます。
```

ℹ️ **すでに設定済みの場合**:
```
ℹ️ すでに設定済みです。
   ファイル: [使用したパス]
```

## 注意事項

- ユーザーの既存設定を尊重する（既存の excludesFile を上書きしない）
- ファイルの末尾に追記する（既存の内容を消さない）
- 何をしたかを明確に報告する
