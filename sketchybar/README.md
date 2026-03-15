# Sketchybar

macOSのカスタムステータスバー。Lua + Cで実装され、高速に動作。

## ディレクトリ構造

```
sketchybar/
├── sketchybarrc          # エントリーポイント（シェルスクリプト）
├── init.lua              # Lua設定のエントリーポイント
├── bar.lua               # バー全体の設定
├── colors.lua            # カラー定義
├── default.lua           # デフォルト設定
├── settings.lua          # 各種設定値
├── icons.lua             # アイコン定義
├── icon_map.sh           # アプリアイコンマッピング
├── icon_updater.sh       # アイコン更新スクリプト
├── items/                # ステータスバーアイテム
│   ├── init.lua
│   ├── front_app.lua     # フロントアプリ表示
│   ├── spaces.lua        # ワークスペース表示
│   ├── calendar.lua      # カレンダー
│   ├── media.lua         # メディア情報
│   ├── menus.lua         # メニュー
│   ├── paw.lua           # Pawアイコン
│   └── widgets/          # ウィジェット
│       ├── battery.lua   # バッテリー
│       ├── cpu.lua       # CPU使用率
│       ├── memory.lua    # メモリ使用率
│       ├── volume.lua    # 音量
│       └── wifi.lua      # WiFi状態
├── helpers/              # ヘルパー機能
│   ├── event_providers/  # イベントプロバイダー（C実装）
│   │   ├── cpu_load/
│   │   ├── memory_load/
│   │   └── network_load/
│   └── menus/            # メニュー機能（C実装）
└── cmap_cal/             # 色マッピングユーティリティ
```

## セットアップ

sketchybarのセットアップは `setup.sh` 実行時に自動的に行われます：
- SbarLua（Luaバインディング）のインストール
- 必要なフォントのダウンロード

### 依存パッケージ（Brewfileで自動インストール）

```bash
brew install lua
brew install switchaudio-osx    # オーディオ切替
brew install nowplaying-cli     # メディア情報
```

### 手動セットアップ（オプション）

SbarLua を手動でインストール:
```bash
git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua
cd /tmp/SbarLua && make install
rm -rf /tmp/SbarLua
```

フォントを手動でダウンロード:
```bash
# sketchybar-app-fontをダウンロード
curl -sL https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.5/sketchybar-app-font.ttf \
  -o ~/Library/Fonts/sketchybar-app-font.ttf
```

## 起動

Aerospaceから自動起動される設定になっています。

手動で起動/再起動する場合:

```bash
# 起動
brew services start sketchybar

# 再起動
brew services restart sketchybar

# 設定リロード
sketchybar --reload
```

## 連携

- **Aerospace**: ワークスペース変更時にsketchybarに通知
- **borders**: 同時に起動

## 参考

- [Sketchybar公式](https://github.com/FelixKratz/SketchyBar)
- [SbarLua](https://github.com/FelixKratz/SbarLua)
