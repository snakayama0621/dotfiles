# ツール使用ルール

## 専用ツールの優先使用（厳守）

Bash コマンドの代わりに、以下の専用ツールを必ず使用すること：

| やりたいこと | NG (Bash) | OK (専用ツール) |
|---|---|---|
| ファイルを読む | `cat`, `head`, `tail` | **Read** |
| ファイルを探す | `ls`, `find` | **Glob** |
| テキスト検索 | `grep`, `rg` | **Grep** |
| ファイル編集 | `sed`, `awk` | **Edit** |
| ファイル作成 | `echo >`, `cat <<EOF` | **Write** |

Bash は専用ツールでは実行できない操作（git, npm, docker, make, curl 等）にのみ使用すること。
