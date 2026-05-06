import Foundation
import SwiftData

enum AppModelContainer {
    @MainActor static let shared: ModelContainer = makeContainer(isStoredInMemoryOnly: false)
    @MainActor static let preview: ModelContainer = makeContainer(isStoredInMemoryOnly: true)

    @MainActor static var previewNote: Note {
        let descriptor = FetchDescriptor<Note>()
        return (try? preview.mainContext.fetch(descriptor))?.first ?? MockNoteFactory.initialNotes().first!
    }

    @MainActor private static func makeContainer(isStoredInMemoryOnly: Bool) -> ModelContainer {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
        let container = try! ModelContainer(for: Note.self, configurations: configuration)
        seedIfNeeded(in: container.mainContext)
        return container
    }

    @MainActor private static func seedIfNeeded(in context: ModelContext) {
        var descriptor = FetchDescriptor<Note>()
        descriptor.fetchLimit = 1

        let existingCount = (try? context.fetchCount(descriptor)) ?? 0
        guard existingCount == 0 else { return }

        for note in MockNoteFactory.initialNotes() {
            context.insert(note)
        }

        try? context.save()
    }
}
