import Observation
import SwiftData

@MainActor
@Observable
final class AppShellModel {
    var selectedTab: AppTab = .record
    var notesPath: [PersistentIdentifier] = []

    func openSavedNote(with id: PersistentIdentifier) {
        selectedTab = .notes
        notesPath = [id]
    }
}
