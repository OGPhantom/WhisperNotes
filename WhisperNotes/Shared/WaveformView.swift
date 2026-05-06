import SwiftUI

struct WaveformView: View {
    enum Mode {
        case idle
        case listening
        case paused
    }

    let mode: Mode

    var body: some View {
        TimelineView(.animation) { timeline in
            let timestamp = timeline.date.timeIntervalSinceReferenceDate

            HStack(spacing: 10) {
                ForEach(0..<7, id: \.self) { index in
                    Capsule(style: .continuous)
                        .fill(barColor(for: index))
                        .frame(width: 10, height: barHeight(for: index, time: timestamp))
                }
            }
            .frame(maxWidth: .infinity)
            .accessibilityHidden(true)
        }
    }

    private func barHeight(for index: Int, time: TimeInterval) -> CGFloat {
        switch mode {
        case .idle:
            return [18, 24, 32, 40, 32, 24, 18][index]
        case .paused:
            return [18, 18, 18, 18, 18, 18, 18][index]
        case .listening:
            let base = 22 + CGFloat(index.isMultiple(of: 2) ? 8 : 0)
            let phase = sin(time * 3.4 + Double(index) * 0.65)
            let pulse = CGFloat(max(phase, -0.4)) * 24
            return max(18, base + pulse)
        }
    }

    private func barColor(for index: Int) -> Color {
        switch mode {
        case .idle:
            return AppTheme.textMuted.opacity(index == 3 ? 0.9 : 0.65)
        case .paused:
            return AppTheme.textSecondary.opacity(index == 3 ? 0.85 : 0.7)
        case .listening:
            return index == 3 ? AppTheme.accent : AppTheme.textSecondary.opacity(0.9)
        }
    }
}
