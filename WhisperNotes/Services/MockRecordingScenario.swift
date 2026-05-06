import Foundation

struct MockRecordingScenario {
    let chunks: [String]
}

extension MockRecordingScenario {
    static let samples: [MockRecordingScenario] = [
        MockRecordingScenario(
            chunks: [
                "I want the recording screen to feel quiet and immediate,",
                "with the live text doing most of the work instead of a giant control surface.",
                "The note should look premium even before any AI rewrite happens,",
                "and the detail view should be clean enough to read like a document."
            ]
        ),
        MockRecordingScenario(
            chunks: [
                "We should test a warmer palette with a burnt orange accent,",
                "keep the notes grid mostly monochrome,",
                "and make the tab bar secondary to the act of capture.",
                "That way the product feels focused instead of ornamental."
            ]
        ),
        MockRecordingScenario(
            chunks: [
                "After stop, the screen should stay in place and shift into review,",
                "let the user add a title,",
                "and optionally reshape the note into an email, list, or summary,",
                "without ever losing the original transcript."
            ]
        )
    ]
}
