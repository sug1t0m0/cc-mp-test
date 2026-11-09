---
name: propose-change
description: やり取りの決まり (plugin dialogue-patterns の語彙、共通の約束、進め方、応答の形、skill) を変えたい、足したいと分かったときに使う。変える所と理由をまとめ、plugin のリポジトリ sug1t0m0/cc-mp-test に issue を立て、書けるなら PR を出し、使う側で打つ更新コマンドを案内する
---

# 決まりを変える案を出す

やり取りの決まりは plugin にだけ置く。使う側の CLAUDE.md やメモリに写して済ませない。変えたいことは、この流れで plugin のリポジトリに出す。

## いつ使うか
- ユーザーから新しい決まりを言われたとき。その場で守りつつ、plugin に出す
- 決まりどうし、または決まりと使う側の CLAUDE.md が食い違っていると分かったとき
- 決まりに無い使い方 (artifact など) を試し、セッションの終わりに「次からも使う」と決まったとき
- 決まりが場面に合わず、但し書きを足したくなったとき。但し書きは足さず、決まりそのものを言い直す案にする

## 流れ
1. 変える所と理由をまとめる。identity (返事のヘッダーの一行目。どの版の決まりの話か) を添える。まとめは、何の話か、何を変えるか、なぜ変えるか、before / after の順。決まりの書き方は下のとおり
2. まとめをユーザーに見せ、出すかどうかを設問として聞く。出すと決まったら、sug1t0m0/cc-mp-test に issue を立てる。本文はまとめそのまま
3. GitHub の道具 (GitHub MCP、または `gh`) が使えて、ユーザーが頼めば、PR を出す。一時ディレクトリに sug1t0m0/cc-mp-test を clone し、branch を作り、`plugins/dialogue-patterns/` の該当ファイルを直して push する。clone できず GitHub MCP だけなら、push_files で branch に直接書く。本文に `Closes #<issue 番号>` を書く。道具が使えなければ、そう言って issue までで止める
4. 使う側で打つ更新コマンドを案内する。main に入った後、使う側のリポジトリで `claude plugin update dialogue-patterns@cc-mp-test` を打ち、Claude Code を立ち上げ直す。新しい版は identity の SHA で分かる

## 決まりの書き方
- 決まりは個別の場面に寄せずに書く。場面ごとの但し書きを足さない。足したくなったら、決まりそのものを言い直す
- 置き場を選ぶ。言葉の定義は glossary.md、どのパターンにも共通の約束は contract.md、パターン decisions の進め方は patterns/decisions/dialogue.md、応答の見た目は output-styles/decisions.md、二つのページの作り方は skills/decision-artifacts/SKILL.md
- 文は短く、一文に一つのこと。日本語で書く。既にある決まりと同じ調子にする
