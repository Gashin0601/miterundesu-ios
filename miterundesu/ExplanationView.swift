//
//  ExplanationView.swift
//  miterundesu
//
//  Created by Claude Code
//

import SwiftUI

struct ExplanationView: View {
    @ObservedObject var settingsManager: SettingsManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let horizontalPadding = screenWidth * 0.05  // 画面幅の5%
            let contentPadding = screenWidth * 0.06     // 画面幅の6%

            ZStack {
                // 背景色
                (settingsManager.isTheaterMode ? Color("TheaterOrange") : Color("MainGreen"))
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // 上部固定ヘッダー
                    HStack {
                        // 左：シアターモードトグル
                        TheaterModeToggle(
                            isTheaterMode: $settingsManager.isTheaterMode,
                            onToggle: {},
                            settingsManager: settingsManager
                        )
                        .padding(.leading, horizontalPadding)
                        .layoutPriority(1)

                        Spacer(minLength: 8)

                        // 中央：ロゴ（スペースに応じて縮小可能）
                        Image("Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 20)
                            .layoutPriority(0)

                        Spacer(minLength: 8)

                        // 右：閉じるボタン（丸バツ）
                        Button(action: {
                            dismiss()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 44, height: 44)
                                Image(systemName: "xmark")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(.black)
                            }
                        }
                        .accessibilityLabel(settingsManager.localizationManager.localizedString("close"))
                        .padding(.trailing, horizontalPadding)
                        .layoutPriority(1)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 8)

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // スペーサー（ヘッダー分）
                    Spacer()
                        .frame(height: 16)

                    // タイトル
                    Text("撮ってないよ、見てるだけ")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, contentPadding)
                        .padding(.bottom, 4)

                    // 区切り線
                    SectionDivider()
                        .padding(.horizontal, contentPadding)

                    // セクション1: アプリの概要
                    VStack(alignment: .leading, spacing: 12) {
                        Text("アプリの概要")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)

                        Text("本アプリは、撮影や録画ではなく、拡大鏡としてスマホを使うためのアプリです。\n\n弱視や老眼など日常的に見えづらさを感じる人が、安心して「見ること」をサポートします。")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.9))
                            .lineSpacing(6)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, contentPadding)

                    // 区切り線
                    SectionDivider()
                        .padding(.horizontal, contentPadding)

                    // セクション2: 実際の機能
                    VStack(alignment: .leading, spacing: 12) {
                        Text("実際の機能")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)

                        VStack(alignment: .leading, spacing: 8) {
                            ExplanationBullet(text: "最大200倍の拡大が可能")
                            ExplanationBullet(text: "撮影した画像は10分後に自動で削除")
                            ExplanationBullet(text: "スクリーンショットや画面録画は不可能")
                        }
                    }
                    .padding(.horizontal, contentPadding)

                    // 区切り線
                    SectionDivider()
                        .padding(.horizontal, contentPadding)

                    // セクション3: 背景
                    VStack(alignment: .leading, spacing: 12) {
                        Text("背景")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)

                        Text("最近のコンビニやスーパーでは、店内撮影を禁止する貼り紙が増えてきています。\n\n見るためにスマホを使っているときに撮影を疑われることも…\n\nそんな時に安心して「見てるんです」と説明できる。\nミテルンデスはそのために作成したアプリです。")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.9))
                            .lineSpacing(6)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, contentPadding)

                    Spacer(minLength: 40)

                    // フッターセクション
                    VStack(spacing: 20) {
                        // 公式サイトリンク
                        Link(destination: URL(string: "https://miterundesu.jp")!) {
                            HStack {
                                Image(systemName: "link.circle.fill")
                                    .font(.system(size: 20))
                                    .accessibilityHidden(true)
                                Text("miterundesu.jp")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.white)
                        }
                        .accessibilityLabel("公式サイト: miterundesu.jp")
                        .accessibilityHint("リンクを開く")

                        // SNSリンク
                        HStack(spacing: contentPadding * 0.4) {
                            // X (Twitter)
                            Link(destination: URL(string: "https://x.com/miterundesu_jp?s=11")!) {
                                XLogoIcon()
                                    .frame(width: 50, height: 50)
                            }

                            // Instagram
                            Link(destination: URL(string: "https://www.instagram.com/miterundesu_jp/?utm_source=ig_web_button_share_sheet")!) {
                                InstagramLogoIcon()
                                    .frame(width: 50, height: 50)
                            }
                        }

                        // コピーライト
                        Text("© 2025 Miterundesu")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                            .padding(.top, 8)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 40)
                }
            }
                }
            }
            .preferredColorScheme(.dark)
        }
    }

}

// MARK: - Section Divider
struct SectionDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.white.opacity(0.25))
            .frame(height: 1)
    }
}

// MARK: - Explanation Bullet
struct ExplanationBullet: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 6) {
            Text("・")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.9))
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.9))
        }
    }
}

// MARK: - X Logo Icon
struct XLogoIcon: View {
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size

            Path { path in
                // X logo の形状（公式ロゴに近い形）
                // 左上から右下への太い斜線
                path.move(to: CGPoint(x: size.width * 0.15, y: size.height * 0.15))
                path.addLine(to: CGPoint(x: size.width * 0.5, y: size.height * 0.5))
                path.addLine(to: CGPoint(x: size.width * 0.85, y: size.height * 0.85))

                path.move(to: CGPoint(x: size.width * 0.15, y: size.height * 0.15))
                path.addLine(to: CGPoint(x: size.width * 0.27, y: size.height * 0.15))
                path.addLine(to: CGPoint(x: size.width * 0.85, y: size.height * 0.85))
                path.addLine(to: CGPoint(x: size.width * 0.73, y: size.height * 0.85))
                path.closeSubpath()

                // 右上から左下への太い斜線
                path.move(to: CGPoint(x: size.width * 0.85, y: size.height * 0.15))
                path.addLine(to: CGPoint(x: size.width * 0.5, y: size.height * 0.5))
                path.addLine(to: CGPoint(x: size.width * 0.15, y: size.height * 0.85))

                path.move(to: CGPoint(x: size.width * 0.85, y: size.height * 0.15))
                path.addLine(to: CGPoint(x: size.width * 0.73, y: size.height * 0.15))
                path.addLine(to: CGPoint(x: size.width * 0.15, y: size.height * 0.85))
                path.addLine(to: CGPoint(x: size.width * 0.27, y: size.height * 0.85))
                path.closeSubpath()
            }
            .fill(Color.white)
        }
    }
}

// MARK: - Instagram Logo Icon
struct InstagramLogoIcon: View {
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size

            ZStack {
                // Instagram カメラアイコン風
                RoundedRectangle(cornerRadius: size.width * 0.24)
                    .stroke(Color.white, lineWidth: size.width * 0.06)
                    .padding(size.width * 0.08)

                Circle()
                    .stroke(Color.white, lineWidth: size.width * 0.06)
                    .frame(width: size.width * 0.48, height: size.width * 0.48)

                Circle()
                    .fill(Color.white)
                    .frame(width: size.width * 0.08, height: size.width * 0.08)
                    .offset(x: size.width * 0.24, y: -size.width * 0.24)
            }
        }
    }
}

struct ExplanationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ExplanationView(settingsManager: SettingsManager())
                .previewDisplayName("Normal Mode")

            ExplanationView(settingsManager: {
                let manager = SettingsManager()
                manager.isTheaterMode = true
                return manager
            }())
            .previewDisplayName("Theater Mode")
        }
    }
}
