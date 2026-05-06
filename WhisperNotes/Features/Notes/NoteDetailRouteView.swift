import SwiftData
import SwiftUI

struct NoteDetailRouteView: View {
    let noteID: PersistentIdentifier

    @Environment(\.modelContext) private var modelContext

    var body: some View {
        if let note = modelContext.model(for: noteID) as? Note {
            NoteDetailView(note: note)
        } else {
            ZStack {
                AppBackgroundView()

                ContentUnavailableView(
                    "Note Unavailable",
                    systemImage: "doc.text.magnifyingglass",
                    description: Text("This note could not be loaded.")
                )
                .foregroundStyle(AppTheme.textSecondary)
            }
        }
    }
}
