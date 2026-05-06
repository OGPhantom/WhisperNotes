import SwiftUI

struct NoteCardView: View {
    let note: Note

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                Text(note.title)
                    .font(.system(.headline, design: .default, weight: .semibold))
                    .foregroundStyle(AppTheme.textPrimary)
                    .multilineTextAlignment(.leading)

                Spacer(minLength: 8)

                if note.hasRefinedNote {
                    Image(systemName: "wand.and.stars.inverse")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(AppTheme.textSecondary)
                        .padding(8)
                        .appCompactPanelStyle(fill: AppTheme.backgroundRaised)
                }
            }

            Text(note.previewText)
                .font(.system(.body, design: .default, weight: .regular))
                .foregroundStyle(AppTheme.textSecondary)
                .lineSpacing(4)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                Text(note.createdAt, format: .dateTime.month(.abbreviated).day())
                    .font(.system(.footnote, design: .default, weight: .medium))
                    .foregroundStyle(AppTheme.textMuted)

                Spacer(minLength: 8)

                Text(note.durationText)
                    .font(.system(.footnote, design: .rounded, weight: .semibold))
                    .foregroundStyle(AppTheme.textMuted)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, minHeight: note.estimatedCardHeight, alignment: .topLeading)
        .appPanelStyle(fill: AppTheme.surfaceMuted)
    }
}
