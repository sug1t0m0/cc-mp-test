#!/usr/bin/env bash
# SessionStart で identity と決まりを標準出力に流す。
# SessionStart の標準出力は Claude の文脈に入る (10,000 字まで)。
# startup、resume、clear、compact、fork のどれでも動く (hooks.json に matcher を書いていない)。
set -u

pattern="decisions"
root="${CLAUDE_PLUGIN_ROOT:-}"
if [ -z "$root" ]; then
  root="$(cd "$(dirname "$0")/.." && pwd)"
fi

# 版 (コミット SHA) は三段で取る。
# 1 install された plugin は cache の <SHA>/ から読まれるので、フォルダ名が SHA ならそれ (12 桁)
# 2 --plugin-dir で worktree を読んでいるときは git に聞く (cache と同じ 12 桁)
# 3 どちらも取れなければ unknown
base="$(basename "$root")"
if printf '%s' "$base" | grep -Eq '^[0-9a-f]{12,40}$'; then
  sha="$(printf '%s' "$base" | cut -c1-12)"
elif sha="$(git -C "$root" rev-parse --short=12 HEAD 2>/dev/null)" && [ -n "$sha" ]; then
  :
else
  sha="unknown"
fi

printf 'dialogue-patterns · %s · %s\n' "$pattern" "$sha"
printf '上の一行が identity (すべての返事と artifact のヘッダーの一行目に、そのまま書く)。以下は plugin dialogue-patterns の決まり (glossary.md、contract.md、patterns/%s/dialogue.md)。\n\n' "$pattern"

for f in glossary.md contract.md "patterns/$pattern/dialogue.md"; do
  if [ -f "$root/$f" ]; then
    cat "$root/$f"
    printf '\n'
  else
    printf '(%s が見つからない。plugin の置き場 %s を確かめる)\n\n' "$f" "$root"
  fi
done
