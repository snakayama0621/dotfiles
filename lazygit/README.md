# Lazygit

ターミナルベースのGit TUI。

## 起動方法

```bash
# lazygitを起動
lazygit

# エイリアス（.zshrcで定義）
lg
```

## 設定内容

### 日本語化

```yaml
gui:
  language: 'ja'
```

### カスタムコマンド（czg統合）

| キー | 動作 |
|------|------|
| `c` | czgでコミット（対話形式） |
| `C` | czg aiでAIコミットメッセージ生成 |

## czgについて

czg (cz-git) はConventional Commitsに準拠したコミットメッセージを生成するツール。

### インストール

czgは `setup.sh` の実行時に自動的にインストールされます。

手動インストール（オプション）:
```bash
npm install -g czg
```

### 設定ファイル

`~/commitlint.config.js` で以下をカスタマイズ:
- コミットタイプ（feat, fix, docs等）
- 日本語メッセージ
- AI生成コミットメッセージ（日本語）

## 参考

- [Lazygit公式](https://github.com/jesseduffield/lazygit)
- [cz-git公式](https://cz-git.qbb.sh/)
