import SwiftData
import SwiftUI
import UIKit

struct NotesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Note.createdAt, order: .reverse) private var notes: [Note]
    @State private var notePendingDeletion: Note?
    @State private var searchText = ""
    @State private var isSearchVisible = false
    @FocusState private var searchFieldFocused: Bool

    var body: some View {
        ZStack {
            AppBackgroundView()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header

                    if visibleNotes.isEmpty {
                        emptyState
                    } else {
                        masonryGrid
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 28)
            }
            .scrollIndicators(.hidden)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .confirmationDialog(
            "Delete this note?",
            isPresented: notePendingDeletionBinding,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                deletePendingNote()
            }

            Button("Cancel", role: .cancel) {
                notePendingDeletion = nil
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Notes")
                        .font(.system(.largeTitle, design: .default, weight: .bold))
                        .tracking(-0.8)
                        .foregroundStyle(AppTheme.textPrimary)

//                    Text(subtitleText)
//                        .font(.system(.subheadline, design: .default, weight: .medium))
//                        .foregroundStyle(AppTheme.textSecondary)
                }

                Spacer(minLength: 0)

                Button {
                    toggleSearch()
                } label: {
                    Image(systemName: isSearchVisible ? "xmark" : "magnifyingglass")
                        .font(.system(.body, design: .default, weight: .semibold))
                        .foregroundStyle(AppTheme.textPrimary)
                        .frame(width: 42, height: 42)
                        .appCompactPanelStyle(fill: AppTheme.backgroundRaised)
                }
                .buttonStyle(.plain)
            }

            if isSearchVisible {
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(.body, design: .default, weight: .semibold))
                        .foregroundStyle(AppTheme.textMuted)

                    TextField("Search notes", text: $searchText)
                        .focused($searchFieldFocused)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .foregroundStyle(AppTheme.textPrimary)

                    if searchText.isEmpty == false {
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(AppTheme.textMuted)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 14)
                .frame(height: 48)
                .appCompactPanelStyle(fill: AppTheme.backgroundRaised)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(searchText.isEmpty ? "No notes yet" : "No results")
                .font(.system(.title3, design: .default, weight: .semibold))
                .foregroundStyle(AppTheme.textPrimary)

            Text(searchText.isEmpty ? "Start a recording and your saved notes will gather here." : "Try a different title or phrase from the note.")
                .font(.system(.body, design: .default, weight: .regular))
                .foregroundStyle(AppTheme.textSecondary)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .appPanelStyle()
    }

    private var masonryGrid: some View {
        let columns = distributedColumns(for: visibleNotes)

        return HStack(alignment: .top, spacing: 16) {
            ForEach(Array(columns.enumerated()), id: \.offset) { _, column in
                LazyVStack(spacing: 16) {
                    ForEach(column) { note in
                        NavigationLink(value: note.persistentModelID) {
                            NoteCardView(note: note)
                        }
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button("Copy", systemImage: "doc.on.doc") {
                                UIPasteboard.general.string = note.noteBody
                            }

                            Button("Delete", systemImage: "trash", role: .destructive) {
                                notePendingDeletion = note
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .top)
            }
        }
    }

    private var visibleNotes: [Note] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard query.isEmpty == false else { return notes }

        return notes.filter { note in
            note.title.localizedCaseInsensitiveContains(query) ||
            note.noteBody.localizedCaseInsensitiveContains(query) ||
            note.transcript.localizedCaseInsensitiveContains(query)
        }
    }

    private var subtitleText: String {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "\(notes.count) captured thoughts"
        }

        return "\(visibleNotes.count) results"
    }

    private func toggleSearch() {
        withAnimation(.easeInOut(duration: 0.24)) {
            isSearchVisible.toggle()
        }

        if isSearchVisible {
            searchFieldFocused = true
        } else {
            searchFieldFocused = false
            searchText = ""
        }
    }

    private var notePendingDeletionBinding: Binding<Bool> {
        Binding(
            get: { notePendingDeletion != nil },
            set: { shouldShow in
                if shouldShow == false {
                    notePendingDeletion = nil
                }
            }
        )
    }

    private func distributedColumns(for notes: [Note]) -> [[Note]] {
        var columns: [[Note]] = [[], []]
        var heights: [CGFloat] = [0, 0]

        for note in notes {
            let targetIndex = heights[0] <= heights[1] ? 0 : 1
            columns[targetIndex].append(note)
            heights[targetIndex] += note.estimatedCardHeight + 16
        }

        return columns
    }

    private func deletePendingNote() {
        guard let notePendingDeletion else { return }
        modelContext.delete(notePendingDeletion)
        try? modelContext.save()
        self.notePendingDeletion = nil
    }
}

#Preview {
    NavigationStack {
        NotesView()
    }
    .modelContainer(AppModelContainer.preview)
}
