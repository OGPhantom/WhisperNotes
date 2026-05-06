import SwiftData
import SwiftUI

struct AppShellView: View {
    @State private var shellModel = AppShellModel()

    var body: some View {
        TabView(
            selection: Binding(
                get: { shellModel.selectedTab },
                set: { shellModel.selectedTab = $0 }
            )
        ) {
            RecordView { noteID in
                shellModel.openSavedNote(with: noteID)
            }
            .tabItem {
                Label("Record", systemImage: "waveform.circle")
            }
            .tag(AppTab.record)

            NavigationStack(
                path: Binding(
                    get: { shellModel.notesPath },
                    set: { shellModel.notesPath = $0 }
                )
            ) {
                NotesView()
                    .navigationDestination(for: PersistentIdentifier.self) { noteID in
                        NoteDetailRouteView(noteID: noteID)
                    }
            }
            .tabItem {
                Label("Notes", systemImage: "square.grid.2x2")
            }
            .tag(AppTab.notes)
        }
        .tint(AppTheme.accent)
        .toolbarBackground(AppTheme.backgroundRaised, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}

#Preview {
    AppShellView()
        .modelContainer(AppModelContainer.preview)
}
