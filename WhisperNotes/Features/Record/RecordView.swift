import SwiftData
import SwiftUI

struct RecordView: View {
    let onSave: (PersistentIdentifier) -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.modelContext) private var modelContext
    @FocusState private var titleFieldFocused: Bool
    @State private var isSettingsPresented = false
    @State private var model = RecordingScreenModel()
    @State private var saveErrorMessage: String?

    var body: some View {
        ZStack {
            AppBackgroundView()

            VStack(spacing: 22) {
                statusRow
                contentPanel
                controls
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)
            .padding(.bottom, 12)
        }
        .sheet(isPresented: rewriteSheetBinding) {
            RewriteSheet(
                initialFormat: model.selectedFormat,
                initialTones: model.selectedTones,
                onApply: { format, tones in
                    model.applyRewrite(format: format, tones: tones)
                },
                onClear: {
                    model.clearRewrite()
                }
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $isSettingsPresented) {
            SettingsPlaceholderView()
        }
        .alert("Unable to Save", isPresented: errorBinding) {
            Button("OK", role: .cancel) {
                saveErrorMessage = nil
            }
        } message: {
            Text(saveErrorMessage ?? "")
        }
        .onChange(of: model.phase) { _, newValue in
            if newValue == .review {
                titleFieldFocused = true
            }
        }
        .animation(
            panelAnimation,
            value: model.phase
        )
    }

    private var rewriteSheetBinding: Binding<Bool> {
        Binding(
            get: { model.isRewriteSheetPresented },
            set: { model.isRewriteSheetPresented = $0 }
        )
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { saveErrorMessage != nil },
            set: { shouldShow in
                if shouldShow == false {
                    saveErrorMessage = nil
                }
            }
        )
    }

    private var statusRow: some View {
        HStack(spacing: 12) {
            Text(model.timerText)
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .monospacedDigit()
                .foregroundStyle(AppTheme.textPrimary)
                .padding(.horizontal, 14)
                .frame(height: 38)
                .appCompactPanelStyle(fill: AppTheme.backgroundRaised)
                .transition(.opacity)

            Spacer(minLength: 0)

            Button {
                isSettingsPresented = true
            } label: {
                Image(systemName: "gearshape")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppTheme.textPrimary)
                    .frame(width: 38, height: 38)
                    .appCompactPanelStyle(fill: AppTheme.backgroundRaised)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Settings")
        }
    }

    private var contentPanel: some View {
        Group {
            switch model.phase {
            case .idle, .listening, .paused:
                capturePanel
            case .review:
                reviewPanel
            }
        }
    }

    private var controls: some View {
        Group {
            switch model.phase {
            case .idle:
                ActionButton(
                    title: "Start Recording",
                    systemImage: "record.circle",
                    variant: .primary,
                    isExpanded: true
                ) {
                    model.startSession()
                }
            case .listening, .paused:
                HStack(alignment: .center, spacing: 16) {
                    ActionButton(
                        title: "Discard",
                        systemImage: "trash",
                        displayMode: .iconOnly,
                        variant: .destructive
                    ) {
                        model.discardSession()
                    }

                    ActionButton(
                        title: "Stop",
                        systemImage: "stop.fill",
                        displayMode: .iconOnly,
                        variant: .primary,
                        isExpanded: true
                    ) {
                        model.stopSession()
                    }

                    ActionButton(
                        title: model.phase == .paused ? "Resume" : "Pause",
                        reservedTitle: "Resume",
                        systemImage: model.phase == .paused ? "play.fill" : "pause.fill",
                        displayMode: .iconOnly,
                        variant: .secondary
                    ) {
                        model.togglePause()
                    }
                }
            case .review:
                VStack(spacing: 12) {
                    ActionButton(
                        title: "Save Note",
                        systemImage: "arrow.down.circle.fill",
                        variant: .primary,
                        isExpanded: true
                    ) {
                        saveNote()
                    }
                    .disabled(model.canSave == false)
                    .opacity(model.canSave ? 1 : 0.55)

                    HStack(spacing: 12) {
                        ActionButton(
                            title: "Refine",
                            systemImage: "wand.and.stars",
                            variant: .secondary,
                            isExpanded: true
                        ) {
                            model.isRewriteSheetPresented = true
                        }

                        ActionButton(
                            title: "Discard",
                            systemImage: "trash",
                            variant: .destructive,
                            isExpanded: true
                        ) {
                            model.discardSession()
                        }
                    }
                }
            }
        }
    }

    private var capturePanel: some View {
        ZStack(alignment: .topLeading) {
            liveTranscriptLayer
                .opacity(isActiveCapture ? 1 : 0)
                .offset(y: isActiveCapture ? 0 : 18)
                .allowsHitTesting(isActiveCapture)

            waveformAndIdleLayer

            VStack {
                Spacer(minLength: 0)

                HStack(spacing: 8) {
                    Image(systemName: isActiveCapture ? statusFooterIcon : "lock")
                        .font(.footnote.weight(.semibold))

                    Text(isActiveCapture ? statusFooterText : "Private & secure")
                        .font(.system(.footnote, design: .default, weight: .medium))
                }
                .foregroundStyle(AppTheme.textMuted)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, minHeight: 520)
        .padding(.horizontal, 24)
        .padding(.vertical, 28)
        .appPanelStyle(fill: AppTheme.surface.opacity(0.92))
    }

    private var reviewPanel: some View {
        VStack(alignment: .leading, spacing: 18) {
            reviewHeader

            WaveformView(mode: model.waveformMode)
                .frame(height: 76)

            tabSwitcher

            ScrollView {
                Text(panelBodyText)
                    .font(.system(.title3, design: .default, weight: .regular))
                    .tracking(-0.4)
                    .foregroundStyle(panelBodyColor)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .textSelection(.enabled)
                    .padding(.bottom, 12)
            }
            .scrollIndicators(.hidden)
            .frame(maxWidth: .infinity, minHeight: 300, alignment: .topLeading)
        }
        .padding(24)
        .appPanelStyle()
    }

    private var reviewHeader: some View {
        VStack(alignment: .leading, spacing: 14) {
            TextField(
                "Add a title",
                text: Binding(
                    get: { model.title },
                    set: { model.title = $0 }
                )
            )
            .focused($titleFieldFocused)
            .textInputAutocapitalization(.words)
            .font(.system(.title2, design: .default, weight: .semibold))
            .foregroundStyle(AppTheme.textPrimary)

            if let styleSummary = model.styleSummary {
                Text(styleSummary)
                    .font(.system(.footnote, design: .default, weight: .semibold))
                    .foregroundStyle(AppTheme.textSecondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .appCompactPanelStyle(fill: AppTheme.surfaceMuted)
            }
        }
    }

    private var tabSwitcher: some View {
        HStack(spacing: 24) {
            ForEach(NoteContentTab.allCases) { tab in
                Button(tab.rawValue) {
                    model.reviewTab = tab
                }
                .buttonStyle(.plain)
                .font(.system(.subheadline, design: .default, weight: .semibold))
                .foregroundStyle(model.reviewTab == tab ? AppTheme.textPrimary : AppTheme.textMuted)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(model.reviewTab == tab ? AppTheme.accent : .clear)
                        .frame(height: 2)
                        .offset(y: 12)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.bottom, 8)
    }

    private var panelBodyText: String {
        switch model.phase {
        case .idle:
            return ""
        case .listening, .paused:
            return model.transcript
        case .review:
            return model.reviewText
        }
    }

    private var panelBodyColor: Color {
        switch model.phase {
        case .idle:
            return AppTheme.textMuted
        case .listening, .paused, .review:
            return AppTheme.textPrimary
        }
    }

    private var isActiveCapture: Bool {
        model.phase == .listening || model.phase == .paused
    }

    private var liveTranscriptLayer: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()
                .frame(height: 86)

            ScrollView {
                Text(panelBodyText)
                    .font(.system(size: 19, weight: .regular, design: .serif))
                    .tracking(-0.2)
                    .lineSpacing(8)
                    .foregroundStyle(AppTheme.textPrimary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .textSelection(.enabled)
                    .padding(.bottom, 12)
            }
            .scrollIndicators(.hidden)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            Spacer()
                .frame(height: 20)
        }
    }

    private var waveformAndIdleLayer: some View {
        VStack(spacing: 16) {
            WaveformView(mode: model.waveformMode)
                .frame(width: 110, height: 54)

            if model.phase == .idle {
                idleCopyContent
                    .transition(.opacity.combined(with: .offset(y: 12)))
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: isActiveCapture ? .top : .center
        )
        .padding(.top, isActiveCapture ? 6 : 0)
        .allowsHitTesting(model.phase == .idle)
    }

    private var idleCopyContent: some View {
        VStack(spacing: 10) {
            Text("Capture a thought.")
                .font(.system(size: 25, weight: .regular, design: .serif))
                .tracking(-0.4)
                .foregroundStyle(AppTheme.textPrimary)

            Text("Tap start and speak.")
                .font(.system(.body, design: .default, weight: .medium))
                .foregroundStyle(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var statusFooterIcon: String {
        model.phase == .paused ? "pause.circle" : "checkmark.circle"
    }

    private var statusFooterText: String {
        model.phase == .paused ? "Paused..." : "Auto-saving..."
    }

    private var panelAnimation: Animation? {
        reduceMotion ? nil : .spring(response: 0.74, dampingFraction: 0.94, blendDuration: 0.24)
    }

    private func saveNote() {
        do {
            let noteID = try model.save(in: modelContext)
            titleFieldFocused = false
            onSave(noteID)
        } catch RecordingScreenModel.SaveError.emptyTitle {
            saveErrorMessage = "Add a title before saving the note."
        } catch RecordingScreenModel.SaveError.emptyTranscript {
            saveErrorMessage = "Record at least a short transcript before saving."
        } catch {
            saveErrorMessage = "The note could not be saved right now."
        }
    }
}

#Preview {
    RecordView { _ in }
        .modelContainer(AppModelContainer.preview)
}

private struct SettingsPlaceholderView: View {
    var body: some View {
        ZStack {
            AppBackgroundView()
        }
        .presentationDragIndicator(.visible)
    }
}
