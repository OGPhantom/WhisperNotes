import SwiftUI

struct RewriteSheet: View {
    let onApply: (RewriteFormat, Set<RewriteTone>) -> Void
    let onClear: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var selectedFormat: RewriteFormat?
    @State private var selectedTones: Set<RewriteTone>

    init(
        initialFormat: RewriteFormat?,
        initialTones: Set<RewriteTone>,
        onApply: @escaping (RewriteFormat, Set<RewriteTone>) -> Void,
        onClear: @escaping () -> Void
    ) {
        self.onApply = onApply
        self.onClear = onClear
        _selectedFormat = State(initialValue: initialFormat)
        _selectedTones = State(initialValue: initialTones)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    formatSection
                    toneSection
                    actionSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 28)
            }
            .scrollIndicators(.hidden)
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("Refine Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }

    private var formatSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Choose a format")
                .font(.system(.headline, design: .default, weight: .semibold))
                .foregroundStyle(AppTheme.textPrimary)

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ],
                spacing: 12
            ) {
                ForEach(RewriteFormat.allCases) { format in
                    Button {
                        selectedFormat = format
                    } label: {
                        VStack(alignment: .leading, spacing: 10) {
                            Image(systemName: format.systemImage)
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(selectedFormat == format ? AppTheme.textPrimary : AppTheme.textSecondary)

                            Text(format.title)
                                .font(.system(.body, design: .default, weight: .semibold))
                                .foregroundStyle(AppTheme.textPrimary)

                            Text(format.subtitle)
                                .font(.system(.footnote, design: .default, weight: .medium))
                                .foregroundStyle(AppTheme.textSecondary)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(18)
                        .frame(maxWidth: .infinity, minHeight: 146, alignment: .topLeading)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.compactCornerRadius, style: .continuous)
                                .fill(selectedFormat == format ? AppTheme.surface : AppTheme.surfaceMuted)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.compactCornerRadius, style: .continuous)
                                .stroke(
                                    selectedFormat == format ? AppTheme.accent : AppTheme.stroke,
                                    lineWidth: 1
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var toneSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Refine the tone")
                .font(.system(.headline, design: .default, weight: .semibold))
                .foregroundStyle(AppTheme.textPrimary)

            FlexibleToneGrid(tones: RewriteTone.allCases, selectedTones: $selectedTones)
        }
    }

    private var actionSection: some View {
        VStack(spacing: 12) {
            ActionButton(
                title: selectedFormat?.title ?? "Choose a Format",
                systemImage: "checkmark.circle.fill",
                variant: .primary,
                isExpanded: true
            ) {
                guard let selectedFormat else { return }
                onApply(selectedFormat, selectedTones)
                dismiss()
            }
            .disabled(selectedFormat == nil)
            .opacity(selectedFormat == nil ? 0.55 : 1)

            ActionButton(
                title: "Use Original",
                systemImage: "arrow.uturn.backward",
                variant: .secondary,
                isExpanded: true
            ) {
                onClear()
                dismiss()
            }
        }
    }
}
