# App Store Connect (asc CLI) セットアップ

このプロジェクトは [asc CLI](https://github.com/rudrankriyam/App-Store-Connect-CLI) と [asc skill pack](https://github.com/rudrankriyam/asc-skills) を使って、App Store Connect の操作（TestFlight アップロード、メタデータ同期、審査提出、スクリーンショット管理、分析レポート取得など）を Claude Code から行えるように構成されている。

## 現状（設定済み）

このマシン上では **セットアップ完了済み**。Claude Code から `asc` コマンドで即座に App Store Connect API を叩ける状態。

- `asc` CLI インストール済み（Homebrew）
- Skill pack 22個インストール済み（`~/.agents/skills/asc-*`、Claude Code へ自動リンク）
- API Key `miterundesu-claude`（Admin権限）発行済み
- 認証情報は macOS システム Keychain に保管済み（`asc auth status` で `validation: works` 確認済み）
- `.p8` ファイルは `~/.apple/asc/AuthKey_*.p8` に保管（+ `.backup` あり）
- `~/.zshrc` に `ASC_APP_ID="6755541195"` 設定済み（`--app` 指定不要）
- App Store Connect 上のアプリ: **ミテルンデス** (App ID: `6755541195`, Bundle ID: `jp-mieruwa.miterundesu`)

動作確認:

```bash
asc auth status --validate  # validation: works が返ればOK
asc apps list               # ミテルンデスが返ればOK
```

---

## ゼロからの再セットアップ手順（別マシン・証明書再発行時）

### 1. CLI のインストール

```bash
brew install asc
asc version  # 1.2.2 以上であることを確認
```

### 2. Skill pack のインストール（一度だけ）

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

### 3. API Key の用意

**既存の `.p8` があれば再利用可**（`~/.apple/asc/AuthKey_BY8ZSAHX69.p8` をバックアップから復元）。

**新規発行する場合:**

1. https://appstoreconnect.apple.com/access/integrations/api を開く
2. 「APIキーを生成」→ 名前入力・権限（Admin推奨）選択 → 生成
3. `AuthKey_XXXXXXXXXX.p8` を**必ずダウンロード**（1回限り、再ダウンロード不可）
4. Key ID（10文字英数字）と Issuer ID（UUID）をメモ
5. 以下のコマンドで `.p8` を安全な場所に配置:

```bash
mkdir -p ~/.apple/asc && chmod 700 ~/.apple/asc
mv ~/Downloads/AuthKey_*.p8 ~/.apple/asc/
chmod 600 ~/.apple/asc/AuthKey_*.p8
# バックアップも作成
cp ~/.apple/asc/AuthKey_*.p8 ~/.apple/asc/AuthKey_*.p8.backup
chmod 600 ~/.apple/asc/AuthKey_*.p8.backup
```

### 4. Apple 側の契約・設定を完了

初回は以下の宣言・同意が必要（ブラウザで https://developer.apple.com/account にアクセスして対応）:

- **Apple Developer Program License Agreement** — 更新時に都度同意
- **DSA（EU デジタルサービス法）トレーダー宣言** — EU 配信しない場合は「トレーダーではない」を選択（証明書類不要）
- **有料アプリ契約** — 無料アプリのみなら不要

これらが未完了だと API が `"A required agreement is missing or has expired"` で全呼び出し失敗する。

### 5. asc auth login

```bash
asc auth login \
  --name "miterundesu" \
  --key-id "YOUR_KEY_ID" \
  --issuer-id "YOUR_ISSUER_ID" \
  --private-key ~/.apple/asc/AuthKey_YOUR_KEY_ID.p8 \
  --network
```

`Successfully registered API key` が返ればOK。Keychain に保管される。

### 6. 環境変数を永続化

```bash
echo '' >> ~/.zshrc
echo '# miterundesu App Store Connect' >> ~/.zshrc
echo 'export ASC_APP_ID="6755541195"' >> ~/.zshrc
source ~/.zshrc
```

これで `asc builds list` など `--app` 省略で動く。

### 7. 確認

```bash
asc auth status --validate  # validation: works
asc apps list               # ミテルンデスが返る
asc doctor                  # No issues found
```

---

## .p8 ファイルのバックアップ（重要）

`.p8` は **1回限りのダウンロード**で、失うと:

- 同じ Key を別マシンで使えなくなる
- 新しい API Key を発行し直すしかない（旧 Key は無効化）

推奨バックアップ先:

- **1Password / パスワードマネージャ** に添付（最推奨）
- **暗号化外部ストレージ**（VeraCrypt ボリューム等）
- **クラウドバックアップ**（iCloud Drive の暗号化フォルダ等）

**絶対にやってはいけない:**

- Git リポジトリにコミット（`.gitignore` で `*.p8` 除外済みだが念のため確認）
- 平文でクラウド同期（Dropbox 直下など）
- Slack / メールに添付

---

## 使い方（Claude Code 経由）

このプロジェクトで Claude Code を起動している状態なら、自然言語で依頼可能:

- 「TestFlight の最新ビルド一覧を表示して」
  → `asc builds list --app $ASC_APP_ID`

- 「バージョン 1.3.0 のリリースを stage して、メタデータを前バージョンから引き継いで」
  → `asc release stage --app $ASC_APP_ID --version 1.3.0 --copy-metadata-from 1.2.0 --dry-run`

- 「審査提出前のチェックをして」
  → `asc validate --app $ASC_APP_ID --version 1.3.0`

- 「このバージョンで submit」
  → `asc publish appstore --app $ASC_APP_ID --ipa ./App.ipa --version 1.3.0 --submit --confirm`

詳細コマンドは `ASC.md`（`asc init` で生成済み）と `asc --help` 参照。

## プロジェクト内のファイル

- **`ASC.md`** — Claude/エージェント向けコマンドリファレンス（`asc init` で自動生成、commit 済）
- **`ASC-SETUP.md`** — このドキュメント
- **`.gitignore`** — `*.p8`, `AuthKey_*.p8`, `.asc/config.json`, `.asc/credentials` を除外

ローカル環境（コミット対象外）:

- `~/.apple/asc/AuthKey_*.p8` — Apple の API プライベートキー
- `~/.apple/asc/AuthKey_*.p8.backup` — バックアップ
- macOS Keychain 内の認証情報
- `~/.agents/skills/asc-*` — 22個の skill（ホームディレクトリ、プロジェクト外）

## 参考リンク

- asc CLI: https://github.com/rudrankriyam/App-Store-Connect-CLI
- Skill pack: https://github.com/rudrankriyam/asc-skills
- App Store Connect API Docs: https://developer.apple.com/documentation/appstoreconnectapi
- API Key 管理画面: https://appstoreconnect.apple.com/access/integrations/api
- Apple Developer Account: https://developer.apple.com/account
