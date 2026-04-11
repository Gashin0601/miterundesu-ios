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
                    VStack(spacing: 24) {
                        // タイトル
                        VStack(spacing: 8) {
                            Text(settingsManager.localizationManager.localizedString("whats_new_title"))
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)

                            Text("v\(appVersion)")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .accessibilityElement(children: .combine)
                        .padding(.top, 60)

                        // 機能紹介
                        Text(settingsManager.localizationManager.localizedString("whats_new_feature_quick_launch_desc"))
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)

                        // ロック画面ウィジェットの追加方法
                        InstructionSection(
                            icon: "lock.circle.fill",
                            title: settingsManager.localizationManager.localizedString("whats_new_lockscreen_title"),
                            steps: [
                                settingsManager.localizationManager.localizedString("whats_new_lockscreen_step1"),
                                settingsManager.localizationManager.localizedString("whats_new_lockscreen_step2"),
                                settingsManager.localizationManager.localizedString("whats_new_lockscreen_step3"),
                            ]
                        )

                        // コントロールセンターの追加方法
                        InstructionSection(
                            icon: "switch.2",
                            title: settingsManager.localizationManager.localizedString("whats_new_controlcenter_title"),
                            steps: [
                                settingsManager.localizationManager.localizedString("whats_new_controlcenter_step1"),
                                settingsManager.localizationManager.localizedString("whats_new_controlcenter_step2"),
                                settingsManager.localizationManager.localizedString("whats_new_controlcenter_step3"),
                            ]
                        )

                        // Siri・ショートカットから起動
                        InstructionSection(
                            icon: "mic.circle.fill",
                            title: settingsManager.localizationManager.localizedString("whats_new_shortcut_title"),
                            steps: [
                                settingsManager.localizationManager.localizedString("whats_new_shortcut_step1"),
                                settingsManager.localizationManager.localizedString("whats_new_shortcut_step2"),
                                settingsManager.localizationManager.localizedString("whats_new_shortcut_step3"),
                            ]
                        )

                        Spacer(minLength: 20)
                    }
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

// MARK: - 手順案内セクション

struct InstructionSection: View {
    let icon: String
    let title: String
    let steps: [String]

    private let stepNumbers = ["❶", "❷", "❸", "❹", "❺"]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // セクションタイトル
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(.white)
                    .accessibilityHidden(true)

                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }

            // 手順リスト
            VStack(alignment: .leading, spacing: 10) {
                ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 10) {
                        Text(stepNumbers[index])
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .frame(width: 24)

                        Text(step)
                            .font(.system(size: 15))
                            .foregroundColor(.white.opacity(0.9))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.15))
        .cornerRadius(16)
        .padding(.horizontal, 30)
        .accessibilityElement(children: .combine)
    }
}

/// 新機能の行表示
struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(.white)
                .frame(width: 50)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)

                Text(description)
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.15))
        .cornerRadius(16)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title)。\(description)")
    }
}

// MARK: - Preview
#Preview {
    WhatsNewView(settingsManager: SettingsManager())
}
