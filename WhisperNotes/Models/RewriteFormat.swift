import Foundation

enum RewriteFormat: String, CaseIterable, Identifiable {
    case email
    case prompt
    case list
    case summary
    case meetingNotes

    var id: String { rawValue }

    var title: String {
        switch self {
        case .email:
            return "Email"
        case .prompt:
            return "Prompt"
        case .list:
            return "List"
        case .summary:
            return "Summary"
        case .meetingNotes:
            return "Meeting Notes"
        }
    }

    var subtitle: String {
        switch self {
        case .email:
            return "Turn the note into a polished message."
        case .prompt:
            return "Shape the note into a ready-to-use prompt."
        case .list:
            return "Break the ideas into a clean structured list."
        case .summary:
            return "Condense the thought into a short brief."
        case .meetingNotes:
            return "Organize the note into meeting-ready sections."
        }
    }

    var systemImage: String {
        switch self {
        case .email:
            return "envelope.open"
        case .prompt:
            return "sparkles.rectangle.stack"
        case .list:
            return "list.bullet.rectangle"
        case .summary:
            return "text.alignleft"
        case .meetingNotes:
            return "person.2.wave.2"
        }
    }
}
