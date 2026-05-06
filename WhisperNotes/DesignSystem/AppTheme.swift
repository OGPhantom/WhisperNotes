import SwiftUI

enum AppTheme {
    static let background = Color(hex: 0x14110F)
    static let backgroundRaised = Color(hex: 0x1B1714)
    static let surface = Color(hex: 0x221D19)
    static let surfaceMuted = Color(hex: 0x29221D)
    static let stroke = Color(hex: 0x312924)
    static let textPrimary = Color(hex: 0xF3EEE8)
    static let textSecondary = Color(hex: 0xB7A99B)
    static let textMuted = Color(hex: 0x8B7E73)
    static let accent = Color(hex: 0xC8642A)
    static let accentPressed = Color(hex: 0xA94F1F)
    static let destructive = Color(hex: 0x8D4133)
    static let shadow = Color.black.opacity(0.34)

    static let backgroundGradient = LinearGradient(
        colors: [Color(hex: 0x1A1513), Color(hex: 0x110E0C)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let topGlow = RadialGradient(
        colors: [accent.opacity(0.18), .clear],
        center: .topTrailing,
        startRadius: 24,
        endRadius: 280
    )

    static let bottomGlow = RadialGradient(
        colors: [Color.white.opacity(0.05), .clear],
        center: .bottomLeading,
        startRadius: 20,
        endRadius: 220
    )

    static let cornerRadius: CGFloat = 28
    static let compactCornerRadius: CGFloat = 20
}

extension View {
    func appPanelStyle(
        fill: Color = AppTheme.surface,
        stroke: Color = AppTheme.stroke.opacity(0.9)
    ) -> some View {
        background(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous)
                .fill(fill)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous)
                .stroke(stroke, lineWidth: 1)
        )
        .shadow(color: AppTheme.shadow, radius: 18, x: 0, y: 12)
    }

    func appCompactPanelStyle(
        fill: Color = AppTheme.surface,
        stroke: Color = AppTheme.stroke.opacity(0.8)
    ) -> some View {
        background(
            RoundedRectangle(cornerRadius: AppTheme.compactCornerRadius, style: .continuous)
                .fill(fill)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.compactCornerRadius, style: .continuous)
                .stroke(stroke, lineWidth: 1)
        )
    }
}

private extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}
