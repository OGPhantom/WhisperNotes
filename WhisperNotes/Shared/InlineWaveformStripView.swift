import SwiftUI

struct InlineWaveformStripView: View {
    let mode: WaveformView.Mode

    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate

            HStack(spacing: 3) {
                ForEach(0..<36, id: \.self) { index in
                    Capsule(style: .continuous)
                        .fill(barColor(for: index))
                        .frame(width: 2, height: barHeight(for: index, time: time))
                }
            }
            .frame(maxWidth: .infinity)
            .accessibilityHidden(true)
        }
    }

    private func barHeight(for index: Int, time: TimeInterval) -> CGFloat {
        switch mode {
        case .idle:
            return 4
        case .paused:
            return 6
        case .listening:
            let wave = sin(time * 3.8 + Double(index) * 0.42)
            let pulse = cos(time * 2.6 + Double(index) * 0.18)
            let blended = max((wave + pulse) * 0.5, -0.25)
            return 6 + CGFloat(blended + 0.25) * 12
        }
    }

    private func barColor(for index: Int) -> Color {
        switch mode {
        case .idle:
            return AppTheme.textMuted.opacity(0.55)
        case .paused:
            return AppTheme.textSecondary.opacity(index.isMultiple(of: 4) ? 0.8 : 0.58)
        case .listening:
            return index.isMultiple(of: 5) ? AppTheme.accent : AppTheme.textSecondary.opacity(0.72)
        }
    }
}
