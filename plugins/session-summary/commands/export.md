---
description: セッション要約をMarkdownファイルに保存
allowed-tools: Write, Bash(date:*), Bash(mkdir:*), Bash(git config:*), Bash(grep:*)
---

# セッション要約のエクスポート

セッション要約を生成し、ファイルに保存してください。

## 手順

1. 出力ディレクトリを作成（存在しない場合）:
   - デフォルト: プロジェクトルートの `.claude-sessions/`
   - コマンド: `mkdir -p .claude-sessions`

2. 日時ベースのファイル名を生成:
   - 形式: `session-YYYY-MM-DD-HHMMSS.md`
   - 例: `session-2025-01-25-143022.md`

3. セッションを分析して要約を作成:
   - セッションのメタデータ（日付、プロジェクト）
   - 完了した作業
   - 決定事項
   - 解決した問題
   - 変更したファイル
   - 次のステップ
   - 残っている課題

4. ファイルに書き込み

5. **Global gitignore の確認**:
   ```bash
   # まず core.excludesFile の設定を確認
   EXCLUDES_FILE=$(git config --global core.excludesFile)

   # 設定がなければデフォルトパスを使用
   if [ -z "$EXCLUDES_FILE" ]; then
     EXCLUDES_FILE="$HOME/.config/git/ignore"
   fi

   # ファイルが存在し、.claude-sessions が含まれているか確認
   grep -q "^\.claude-sessions$" "$EXCLUDES_FILE" 2>/dev/null
   ```

6. 保存後に報告:
   - 保存したファイルのフルパス
   - 保存内容の簡単な確認
   - **gitignore 未設定の場合**: 以下のメッセージを表示
     ```
     💡 ヒント: `.claude-sessions` が global gitignore に設定されていません。
     全プロジェクトで自動的に ignore するには `/session-summary:setup` を実行してください。
     ```

## 出力ファイル形式

```markdown
# セッション要約: [簡潔なタイトル]

**日付**: [YYYY-MM-DD HH:MM]
**プロジェクト**: [プロジェクト名またはパス]

## 完了した作業
- [項目]

## 決定事項
- [決定]: [理由]

## 解決した問題
- [問題] → [解決策]

## 変更したファイル
- `[パス]`: [説明]

## 次のステップ
- [ ] [タスク]

## メモ
[その他の補足]
```

## 引数について

ユーザーがコマンドの後に引数を指定した場合（例: `/export 認証機能`）、それをファイル名やタイトルの一部として使用してください。

指定された引数: $ARGUMENTS
