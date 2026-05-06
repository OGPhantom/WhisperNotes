import Foundation

enum MockRewriteFormatter {
    static func rewrite(
        transcript: String,
        format: RewriteFormat,
        tones: Set<RewriteTone>
    ) -> String {
        let source = transcript.trimmingCharacters(in: .whitespacesAndNewlines)
        guard source.isEmpty == false else { return transcript }

        let sentences = cleanedSentences(from: source)
        var result: String

        switch format {
        case .email:
            result = emailBody(from: sentences)
        case .prompt:
            result = promptBody(from: sentences)
        case .list:
            result = listBody(from: sentences)
        case .summary:
            result = summaryBody(from: sentences)
        case .meetingNotes:
            result = meetingNotesBody(from: sentences)
        }

        if tones.contains(.professional) {
            result = professionalTone(for: result, format: format)
        }

        if tones.contains(.casual) {
            result = casualTone(for: result, format: format)
        }

        if tones.contains(.clearer) {
            result = clearerTone(for: result)
        }

        if tones.contains(.shorter) {
            result = shorterTone(for: result, format: format)
        }

        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func cleanedSentences(from transcript: String) -> [String] {
        transcript
            .replacingOccurrences(of: "\n", with: " ")
            .split(whereSeparator: { ".!?".contains($0) })
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { $0.isEmpty == false }
    }

    private static func emailBody(from sentences: [String]) -> String {
        let intro = sentences.first ?? "Here is the note."
        let body = sentences.dropFirst().prefix(3).map { "- \($0)." }.joined(separator: "\n")

        return """
        Subject: Follow-up

        Hi team,

        \(intro).

        \(body)

        Best,
        Nikita
        """
    }

    private static func promptBody(from sentences: [String]) -> String {
        let bullets = sentences.prefix(4).map { "- \($0)" }.joined(separator: "\n")

        return """
        Create an output using the context below:

        \(bullets)

        Prioritize clarity, brevity, and an editorial tone.
        """
    }

    private static func listBody(from sentences: [String]) -> String {
        sentences
            .map { "• \($0.trimmingCharacters(in: .whitespacesAndNewlines))" }
            .joined(separator: "\n")
    }

    private static func summaryBody(from sentences: [String]) -> String {
        let summary = sentences.prefix(2).joined(separator: ". ")
        return summary.isEmpty ? "" : "\(summary)."
    }

    private static func meetingNotesBody(from sentences: [String]) -> String {
        let overview = sentences.first ?? ""
        let details = sentences.dropFirst().prefix(2).map { "- \($0)." }.joined(separator: "\n")
        let nextStep = sentences.dropFirst(3).first ?? "Review and refine the note."

        return """
        Overview
        \(overview).

        Key Points
        \(details)

        Next Step
        \(nextStep).
        """
    }

    private static func professionalTone(for text: String, format: RewriteFormat) -> String {
        switch format {
        case .email:
            return text.replacingOccurrences(of: "Hi team,", with: "Hello team,")
        case .prompt:
            return text + "\nMaintain a measured professional tone."
        case .list, .summary, .meetingNotes:
            return text
        }
    }

    private static func casualTone(for text: String, format: RewriteFormat) -> String {
        switch format {
        case .email:
            return text.replacingOccurrences(of: "Hello team,", with: "Hey team,")
        case .prompt:
            return text.replacingOccurrences(of: "Prioritize clarity, brevity, and an editorial tone.", with: "Keep it clear, direct, and easy to act on.")
        case .list, .summary, .meetingNotes:
            return text
        }
    }

    private static func clearerTone(for text: String) -> String {
        text
            .replacingOccurrences(of: "  ", with: " ")
            .replacingOccurrences(of: "\n\n\n", with: "\n\n")
    }

    private static func shorterTone(for text: String, format: RewriteFormat) -> String {
        switch format {
        case .email:
            let lines = text.components(separatedBy: .newlines)
            return lines.enumerated()
                .filter { index, line in
                    index < 7 || line.hasPrefix("Best")
                }
                .map(\.element)
                .joined(separator: "\n")
        case .prompt, .meetingNotes:
            return text.components(separatedBy: .newlines).prefix(7).joined(separator: "\n")
        case .list:
            return text.components(separatedBy: .newlines).prefix(3).joined(separator: "\n")
        case .summary:
            return text
        }
    }
}
