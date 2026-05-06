import Foundation
import CoreGraphics
import SwiftData

@Model
final class Note {
    var title: String
    var transcript: String
    var noteBody: String
    var createdAt: Date
    var duration: TimeInterval

    init(
        title: String,
        transcript: String,
        noteBody: String,
        createdAt: Date,
        duration: TimeInterval
    ) {
        self.title = title
        self.transcript = transcript
        self.noteBody = noteBody
        self.createdAt = createdAt
        self.duration = duration
    }
}

extension Note {
    var hasRefinedNote: Bool {
        normalized(noteBody) != normalized(transcript)
    }

    var previewText: String {
        let source = noteBody.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? transcript : noteBody
        let flattened = source
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "  ", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return String(flattened.prefix(180))
    }

    var estimatedCardHeight: CGFloat {
        let titleWeight = min(CGFloat(title.count) * 0.7, 38)
        let textWeight = min(CGFloat(previewText.count) * 0.55, 120)
        return 160 + titleWeight + textWeight
    }

    var durationText: String {
        let totalSeconds = max(Int(duration.rounded()), 1)
        return String(format: "%d:%02d", totalSeconds / 60, totalSeconds % 60)
    }

    func text(for tab: NoteContentTab) -> String {
        switch tab {
        case .note:
            return noteBody
        case .transcript:
            return transcript
        }
    }

    private func normalized(_ text: String) -> String {
        text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\n", with: " ")
    }
}
