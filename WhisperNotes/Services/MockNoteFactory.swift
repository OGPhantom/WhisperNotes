import Foundation

enum MockNoteFactory {
    static func initialNotes() -> [Note] {
        let now = Date.now

        let transcriptOne = """
        We should simplify the onboarding so users can start recording immediately, then surface settings only after the first successful note.
        """

        let transcriptTwo = """
        I want a landing concept for the iOS app that feels quiet and premium, with warm dark tones, a strong reading surface, and a single clear recording action.
        """

        let transcriptThree = """
        Interview feedback: strong systems thinking, fast product intuition, but we need clearer examples of shipping consumer polish under tight constraints.
        """

        let transcriptFour = """
        Grocery list for tomorrow: lemons, sea salt, olive oil, tomatoes, parsley, coffee beans, and sparkling water for the studio.
        """

        let transcriptFive = """
        Team sync notes: performance on the latest build looks stable, but we still need to tighten the notes grid scrolling and reduce the visual noise in the detail header.
        """

        let transcriptSix = """
        Prompt draft: write a focused product brief for a privacy-first voice notes app with local transcription, fast capture, and calm premium visual design.
        """

        return [
            Note(
                title: "Onboarding Direction",
                transcript: transcriptOne,
                noteBody: MockRewriteFormatter.rewrite(
                    transcript: transcriptOne,
                    format: .meetingNotes,
                    tones: [.clearer]
                ),
                createdAt: now.addingTimeInterval(-3600),
                duration: 74
            ),
            Note(
                title: "Visual Direction",
                transcript: transcriptTwo,
                noteBody: transcriptTwo,
                createdAt: now.addingTimeInterval(-10_800),
                duration: 58
            ),
            Note(
                title: "Candidate Debrief",
                transcript: transcriptThree,
                noteBody: MockRewriteFormatter.rewrite(
                    transcript: transcriptThree,
                    format: .summary,
                    tones: [.professional, .shorter]
                ),
                createdAt: now.addingTimeInterval(-19_200),
                duration: 83
            ),
            Note(
                title: "Tomorrow Errands",
                transcript: transcriptFour,
                noteBody: MockRewriteFormatter.rewrite(
                    transcript: transcriptFour,
                    format: .list,
                    tones: []
                ),
                createdAt: now.addingTimeInterval(-28_800),
                duration: 22
            ),
            Note(
                title: "Performance Review",
                transcript: transcriptFive,
                noteBody: MockRewriteFormatter.rewrite(
                    transcript: transcriptFive,
                    format: .email,
                    tones: [.professional]
                ),
                createdAt: now.addingTimeInterval(-48_000),
                duration: 91
            ),
            Note(
                title: "Prompt Draft",
                transcript: transcriptSix,
                noteBody: MockRewriteFormatter.rewrite(
                    transcript: transcriptSix,
                    format: .prompt,
                    tones: [.clearer]
                ),
                createdAt: now.addingTimeInterval(-72_000),
                duration: 64
            )
        ]
    }
}
