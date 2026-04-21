//
//  WhatsNewView.swift
//  miterundesu
//
//  Created by Claude Code
//

import SwiftUI

/// 新機能案内ビュー
struct WhatsNewView: View {
    @ObservedObject var settingsManager: SettingsManager
    @ObservedObject private var whatsNewManager = WhatsNewManager.shared
    @Environment(\.dismiss) var dismiss

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    var body: some View {
        ZStack {
            // 背景
            Color("MainGreen")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // タイトル
                        VStack(alignment: .leading, spacing: 8) {
                            Text(settingsManager.localizationManager.localizedString("whats_new_title"))
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)

                            Text("v\(appVersion)")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .accessibilityElement(children: .combine)
                        .padding(.top, 60)

                        // 見出し
                        Text(settingsManager.localizationManager.localizedString("whats_new_headline"))
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)

                        // 変更点リスト
                        VStack(alignment: .leading, spacing: 14) {
                            BulletItem(text: settingsManager.localizationManager.localizedString("whats_new_bullet1"))
                            BulletItem(text: settingsManager.localizationManager.localizedString("whats_new_bullet2"))
                        }
                        .padding(.top, 8)

                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 30)
                }

                // 閉じるボタン（固定）
                Button(action: {
                    whatsNewManager.markWhatsNewAsSeen()
                    dismiss()
                }) {
                    Text(settingsManager.localizationManager.localizedString("whats_new_close"))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color("MainGreen"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .cornerRadius(12)
                }
                .accessibilityLabel(settingsManager.localizationManager.localizedString("whats_new_close"))
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
                .padding(.top, 12)
            }
        }
    }
}

// MARK: - Bullet Item

/// 変更点リストの1項目
struct BulletItem: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text("・")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.9))
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Preview
#Preview {
    WhatsNewView(settingsManager: SettingsManager())
}
