import SwiftUI

struct ActionButton: View {
    enum DisplayMode {
        case label
        case iconOnly
    }

    enum Variant {
        case primary
        case secondary
        case destructive
    }

    let title: String
    let reservedTitle: String?
    let systemImage: String?
    let displayMode: DisplayMode
    let variant: Variant
    let isExpanded: Bool
    let width: CGFloat?
    let action: () -> Void

    init(
        title: String,
        reservedTitle: String? = nil,
        systemImage: String? = nil,
        displayMode: DisplayMode = .label,
        variant: Variant,
        isExpanded: Bool = false,
        width: CGFloat? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.reservedTitle = reservedTitle
        self.systemImage = systemImage
        self.displayMode = displayMode
        self.variant = variant
        self.isExpanded = isExpanded
        self.width = width
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            buttonLabel
                .font(.system(.body, design: .default, weight: .semibold))
                .foregroundStyle(foregroundColor)
                .frame(maxWidth: isExpanded ? .infinity : nil)
                .frame(width: width)
                .frame(height: 56)
                .padding(.horizontal, horizontalPadding)
                .background(backgroundView)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var buttonLabel: some View {
        if let systemImage {
            if displayMode == .iconOnly {
                ZStack {
                    Label(reservedTitle ?? title, systemImage: systemImage)
                        .opacity(0)
                        .accessibilityHidden(true)

                    Image(systemName: systemImage)
                }
                .accessibilityLabel(Text(title))
            } else {
                Label(title, systemImage: systemImage)
            }
        } else {
            Text(title)
        }
    }

    private var horizontalPadding: CGFloat {
        if isExpanded || width != nil {
            return 0
        }

        return 18
    }

    private var foregroundColor: Color {
        switch variant {
        case .primary:
            return AppTheme.textPrimary
        case .secondary:
            return AppTheme.textPrimary
        case .destructive:
            return AppTheme.textSecondary
        }
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch variant {
        case .primary:
            RoundedRectangle(cornerRadius: AppTheme.compactCornerRadius, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [AppTheme.accent, AppTheme.accentPressed],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        case .secondary:
            RoundedRectangle(cornerRadius: AppTheme.compactCornerRadius, style: .continuous)
                .fill(AppTheme.surfaceMuted)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.compactCornerRadius, style: .continuous)
                        .stroke(AppTheme.stroke, lineWidth: 1)
                )
        case .destructive:
            RoundedRectangle(cornerRadius: AppTheme.compactCornerRadius, style: .continuous)
                .fill(AppTheme.destructive.opacity(0.18))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.compactCornerRadius, style: .continuous)
                        .stroke(AppTheme.destructive.opacity(0.35), lineWidth: 1)
                )
        }
    }
}
