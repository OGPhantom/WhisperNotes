import SwiftUI

struct FlexibleToneGrid: View {
    let tones: [RewriteTone]
    @Binding var selectedTones: Set<RewriteTone>

    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.adaptive(minimum: 132), spacing: 12)
            ],
            spacing: 12
        ) {
            ForEach(tones) { tone in
                Button {
                    toggle(tone)
                } label: {
                    Text(tone.title)
                        .font(.system(.subheadline, design: .default, weight: .semibold))
                        .foregroundStyle(selectedTones.contains(tone) ? AppTheme.textPrimary : AppTheme.textSecondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 46)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(selectedTones.contains(tone) ? AppTheme.surface : AppTheme.surfaceMuted)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(
                                    selectedTones.contains(tone) ? AppTheme.accent : AppTheme.stroke,
                                    lineWidth: 1
                                )
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func toggle(_ tone: RewriteTone) {
        if selectedTones.contains(tone) {
            selectedTones.remove(tone)
        } else {
            selectedTones.insert(tone)
        }
    }
}
