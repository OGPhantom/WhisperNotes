import Foundation

enum NoteContentTab: String, CaseIterable, Identifiable {
    case note = "Note"
    case transcript = "Transcript"

    var id: String { rawValue }
}
