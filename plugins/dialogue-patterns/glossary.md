# 語彙

この plugin の決まりで使う言葉。どのパターンにも共通。

- **セッション**: Claude Code の会話。立ち上げから閉じるまで。resume で戻れば続く
- **パターン**: やり取りの進め方の一組。進め方の決まり (`patterns/<名前>/dialogue.md`)、応答の形 (output style)、それを支える skill からなる。今あるのは `decisions`
- **identity**: この plugin の名前、パターン、版を一行で示すもの。`dialogue-patterns · <パターン> · <コミット SHA>`。セッションの始まりに hook が作る
- **使う側**: この plugin を有効にしたリポジトリと、そこで作業する人
- **決まり**: この plugin が定める、やり取りの約束。glossary.md (語彙)、contract.md (共通の約束)、パターンの dialogue.md (進め方)、output style (応答の形)、skill の中身
