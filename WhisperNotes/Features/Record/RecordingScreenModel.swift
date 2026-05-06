import Foundation
import Observation
import SwiftData

@MainActor
@Observable
final class RecordingScreenModel {
    enum Phase {
        case idle
        case listening
        case paused
        case review
    }

    enum SaveError: Error {
        case emptyTitle
        case emptyTranscript
    }

    var phase: Phase = .idle
    var transcript = ""
    var noteText = ""
    var title = ""
    var elapsedSeconds: TimeInterval = 0
    var reviewTab: NoteContentTab = .note
    var selectedFormat: RewriteFormat?
    var selectedTones: Set<RewriteTone> = []
    var isRewriteSheetPresented = false

    private var chunkIndex = 0
    private var scenarioIndex = 0
    private var recordingTask: Task<Void, Never>?
    private var discardResetTask: Task<Void, Never>?

    var statusText: String {
        switch phase {
        case .idle:
            return "Idle"
        case .listening:
            return "Listening"
        case .paused:
            return "Paused"
        case .review:
            return "Review"
        }
    }

    var timerText: String {
        let seconds = max(Int(elapsedSeconds.rounded()), 0)
        return String(format: "%d:%02d", seconds / 60, seconds % 60)
    }

    var canSave: Bool {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false &&
        transcript.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
    }

    var reviewText: String {
        switch reviewTab {
        case .note:
            return noteText
        case .transcript:
            return transcript
        }
    }

    var styleSummary: String? {
        guard let selectedFormat else { return nil }

        let toneTitles = selectedTones
            .sorted { $0.rawValue < $1.rawValue }
            .map(\.title)

        if toneTitles.isEmpty {
            return selectedFormat.title
        }

        return ([selectedFormat.title] + toneTitles).joined(separator: " · ")
    }

    var waveformMode: WaveformView.Mode {
        switch phase {
        case .idle:
            return .idle
        case .listening:
            return .listening
        case .paused:
            return .paused
        case .review:
            return .idle
        }
    }

    func startSession() {
        discardResetTask?.cancel()
        cancelRecordingTask()
        resetDraftForCurrentScenario()
        phase = .listening

        recordingTask = Task { [weak self] in
            var tick = 0

            while Task.isCancelled == false {
                do {
                    try await Task.sleep(for: .milliseconds(420))
                } catch {
                    break
                }

                guard Task.isCancelled == false else { break }
                guard let self else { break }
                guard self.phase == .listening else { continue }

                self.elapsedSeconds += 0.42
                tick += 1

                if tick.isMultiple(of: 2) {
                    self.appendNextChunk()
                }
            }
        }
    }

    func togglePause() {
        switch phase {
        case .listening:
            phase = .paused
        case .paused:
            phase = .listening
        case .idle, .review:
            break
        }
    }

    func stopSession() {
        guard phase == .listening || phase == .paused else { return }
        cancelRecordingTask()
        phase = .review
        reviewTab = .note
        isRewriteSheetPresented = false
    }

    func discardSession() {
        cancelRecordingTask()
        discardResetTask?.cancel()
        isRewriteSheetPresented = false
        phase = .idle

        discardResetTask = Task { [weak self] in
            do {
                try await Task.sleep(for: .milliseconds(540))
            } catch {
                return
            }

            guard let self else { return }
            self.advanceScenario()
            self.resetDraftForCurrentScenario()
        }
    }

    func applyRewrite(format: RewriteFormat, tones: Set<RewriteTone>) {
        selectedFormat = format
        selectedTones = tones
        noteText = MockRewriteFormatter.rewrite(transcript: transcript, format: format, tones: tones)
        reviewTab = .note
        isRewriteSheetPresented = false
    }

    func clearRewrite() {
        selectedFormat = nil
        selectedTones = []
        noteText = transcript
        reviewTab = .note
        isRewriteSheetPresented = false
    }

    func save(in modelContext: ModelContext) throws -> PersistentIdentifier {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedTranscript = transcript.trimmingCharacters(in: .whitespacesAndNewlines)

        guard trimmedTitle.isEmpty == false else {
            throw SaveError.emptyTitle
        }

        guard trimmedTranscript.isEmpty == false else {
            throw SaveError.emptyTranscript
        }

        let note = Note(
            title: trimmedTitle,
            transcript: trimmedTranscript,
            noteBody: noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? trimmedTranscript : noteText,
            createdAt: .now,
            duration: max(elapsedSeconds, 1)
        )

        modelContext.insert(note)
        try modelContext.save()

        let identifier = note.persistentModelID
        advanceScenario()
        resetDraftForCurrentScenario()
        phase = .idle
        return identifier
    }

    private var currentScenario: MockRecordingScenario {
        MockRecordingScenario.samples[scenarioIndex % MockRecordingScenario.samples.count]
    }

    private func advanceScenario() {
        scenarioIndex += 1
    }

    private func cancelRecordingTask() {
        recordingTask?.cancel()
        recordingTask = nil
    }

    private func resetDraftForCurrentScenario() {
        transcript = ""
        noteText = ""
        title = ""
        elapsedSeconds = 0
        reviewTab = .note
        selectedFormat = nil
        selectedTones = []
        isRewriteSheetPresented = false
        chunkIndex = 0
    }

    private func appendNextChunk() {
        guard chunkIndex < currentScenario.chunks.count else { return }

        let nextChunk = currentScenario.chunks[chunkIndex]
        transcript += transcript.isEmpty ? nextChunk : " \(nextChunk)"
        chunkIndex += 1

        if selectedFormat == nil {
            noteText = transcript
        }
    }
}
