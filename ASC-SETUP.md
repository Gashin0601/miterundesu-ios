# App Store Connect (asc CLI) セットアップ

このプロジェクトは [asc CLI](https://github.com/rudrankriyam/App-Store-Connect-CLI) と [asc skill pack](https://github.com/rudrankriyam/asc-skills) を使って、App Store Connect の操作（TestFlight アップロード、メタデータ同期、審査提出、スクリーンショット管理、分析レポート取得など）を Claude Code から行えるように構成されている。

## 1. CLI のインストール

```bash
brew install asc
asc version  # 1.2.2 以上であることを確認
```

## 2. Skill pack のインストール（一度だけ）

Claude Code / 他の AI エージェントに asc のワークフロー知識を与える。

```bash
npx -y skills add https://github.com/rudrankriyam/asc-skills.git -y -g
```

`~/.agents/skills/asc-*` に22個のskillが配置され、Claude Code に自動的にシンボリックリンクされる。含まれる主なskill:

- `asc-cli-usage` — コマンド・フラグ・ページネーションのガイダンス
- `asc-xcode-build` — xcodebuild でのアーカイブ・エクスポート・バージョン管理
- `asc-testflight-orchestration` — TestFlight ビルド・グループ管理
- `asc-release-flow` — App Store 審査提出の readiness チェック
- `asc-workflow` — repo-local 自動化グラフ (.asc/workflow.json)
- `asc-signing-setup` — 証明書・プロファイルの管理
- `asc-whats-new-writer` — リリースノート執筆支援
- `asc-shots-pipeline` — シミュレータでのスクショ自動化（experimental）
- 他

## 3. App Store Connect API Key の発行

App Store Connect の管理画面で API Key を発行する:

1. https://appstoreconnect.apple.com/access/integrations/api を開く
2. 「キーを生成」をクリック
3. 権限は **Admin**（全機能を使いたい場合）または **App Manager** を選択
4. ダウンロードされる `AuthKey_XXXXXXXXXX.p8` を安全な場所に保管（**一度しかダウンロードできない**）
5. 同画面に表示される以下をメモ:
   - **Issuer ID**（チーム全体で共通）
   - **Key ID**（10文字の英数字、ファイル名の XXXXXXXXXX 部分と同じ）

`.p8` ファイルは絶対にコミットしないこと。`.gitignore` で `*.p8` および `AuthKey_*.p8` を除外済み。

## 4. asc auth login

`.p8` を安全な場所（例: `~/.apple/asc/AuthKey_XXXXXXXXXX.p8`）に置いた上で:

```bash
asc auth login \
  --name "miterundesu" \
  --key-id "YOUR_KEY_ID" \
  --issuer-id "YOUR_ISSUER_ID" \
  --private-key ~/.apple/asc/AuthKey_YOUR_KEY_ID.p8 \
  --network
```

認証情報は macOS Keychain に保管される（推奨）。CI などキーチェーンが使えない環境では `--bypass-keychain` フラグで設定ファイルに保管することも可能だが、その場合は設定ファイルを厳重に管理すること。

動作確認:

```bash
asc auth status --validate
asc auth doctor
asc apps list  # アプリ一覧が取れれば認証成功
```

## 5. 使い方（Claude Code 経由）

このプロジェクトで Claude Code を起動している状態なら、以下のような依頼ができる:

- 「TestFlight の最新ビルド一覧を表示して」
  → Claude が `asc builds list --app <APP_ID>` を実行

- 「バージョン 1.3.0 のリリースを stage して、メタデータを前バージョンから引き継いで」
  → Claude が `asc release stage --app <APP_ID> --version 1.3.0 --copy-metadata-from 1.2.0 --dry-run` を実行

- 「審査提出前のチェックをして」
  → Claude が `asc validate --app <APP_ID> --version 1.3.0` を実行

具体的なコマンド・フラグはプロジェクトルートの `ASC.md`（`asc init` で生成）に一覧化されており、Claude Code はこのファイルを参照する。

## 6. プロジェクト内のファイル構成

このプロジェクトで asc 関連として追加されているもの:

- `ASC.md` — Claude/エージェント向けのコマンドリファレンス（`asc init` で生成、commit する）
- `ASC-SETUP.md` — このドキュメント（人間向けセットアップ手順）
- `.gitignore` に `*.p8`, `.asc/config.json` などを追加

ローカルでのみ使うファイル（コミットしない）:
- `.asc/config.json` — 認証設定のローカル上書き（作成した場合）
- `AuthKey_*.p8` — Apple の API プライベートキー
- `~/.agents/skills/asc-*` — ホームディレクトリに配置される Skill（プロジェクト外）

## 7. ビルド+アップロードのワークフロー例

v1.3.0 を TestFlight に配布する最小ステップ（仮）:

```bash
# 1. バージョン/ビルド番号を設定（既に pbxproj で 1.3.0 になっている）
# 2. アーカイブを作成
xcodebuild -scheme miterundesu \
  -configuration Release \
  -archivePath ./build/miterundesu.xcarchive \
  -allowProvisioningUpdates \
  archive

# 3. IPA をエクスポート
xcodebuild -exportArchive \
  -archivePath ./build/miterundesu.xcarchive \
  -exportPath ./build/export \
  -exportOptionsPlist ./ExportOptions.plist

# 4. TestFlight にアップロード
asc testflight upload \
  --app "YOUR_APP_ID" \
  --ipa ./build/export/miterundesu.ipa

# 5. 社内テスター向けグループへ追加
asc testflight groups add-build \
  --app "YOUR_APP_ID" \
  --group "Internal" \
  --build "LATEST"
```

細かい手順は Claude Code に相談すれば Skill を参照しながら案内してくれる。

## 参考リンク

- asc CLI: https://github.com/rudrankriyam/App-Store-Connect-CLI
- Skill pack: https://github.com/rudrankriyam/asc-skills
- App Store Connect API Docs: https://developer.apple.com/documentation/appstoreconnectapi
