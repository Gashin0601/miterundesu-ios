import AppIntents

struct LaunchMiterundesuIntent: AppIntent {
    static var title: LocalizedStringResource = "ミテルンデスを開く"
    static var description = IntentDescription("拡大鏡アプリ「ミテルンデス」を起動します。")
    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {
        return .result()
    }
}

/// Siri/ショートカットアプリからの自動検出用プロバイダ
struct MiterundesuAppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: LaunchMiterundesuIntent(),
            phrases: [
                "\(.applicationName)を開く",
                "\(.applicationName)を起動",
                "\(.applicationName)を起動して",
                "Open \(.applicationName)",
                "Launch \(.applicationName)",
                "Start \(.applicationName)",
            ],
            shortTitle: "ミテルンデスを開く",
            systemImageName: "plus.magnifyingglass"
        )
    }
}
