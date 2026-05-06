import SwiftData
import SwiftUI
import UIKit

struct NoteDetailView: View {
    let note: Note

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab: NoteContentTab = .note
    @State private var isRewriteSheetPresented = false
    @State private var isDeleteConfirmationPresented = false
    @State private var isCopyToastVisible = false

    var body: some View {
        ZStack {
            AppBackgroundView()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    tabs
                    bodyPanel
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 28)
            }
            .scrollIndicators(.hidden)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("Copy", systemImage: "doc.on.doc") {
                    UIPasteboard.general.string = note.text(for: selectedTab)
                    isCopyToastVisible = true
                }
                .labelStyle(.iconOnly)

                Button("Refine", systemImage: "wand.and.stars") {
                    isRewriteSheetPresented = true
                }
                .labelStyle(.iconOnly)

                Button("Delete", systemImage: "trash") {
                    isDeleteConfirmationPresented = true
                }
                .labelStyle(.iconOnly)
            }
        }
        .sheet(isPresented: $isRewriteSheetPresented) {
            RewriteSheet(
                initialFormat: note.hasRefinedNote ? .summary : nil,
                initialTones: [],
                onApply: { format, tones in
                    note.noteBody = MockRewriteFormatter.rewrite(
                        transcript: note.transcript,
                        format: format,
                        tones: tones
                    )
                    try? modelContext.save()
                    selectedTab = .note
                },
                onClear: {
                    note.noteBody = note.transcript
                    try? modelContext.save()
                    selectedTab = .note
                }
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .confirmationDialog(
            "Delete this note?",
            isPresented: $isDeleteConfirmationPresented,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                modelContext.delete(note)
                try? modelContext.save()
                dismiss()
            }

            Button("Cancel", role: .cancel) { }
        }
        .overlay(alignment: .bottom) {
            if isCopyToastVisible {
                Text("Copied")
                    .font(.system(.footnote, design: .default, weight: .semibold))
                    .foregroundStyle(AppTheme.textPrimary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .appCompactPanelStyle(fill: AppTheme.backgroundRaised)
                    .padding(.bottom, 28)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .onChange(of: isCopyToastVisible) { _, newValue in
            guard newValue else { return }

            Task { @MainActor in
                try? await Task.sleep(for: .seconds(1.4))
                isCopyToastVisible = false
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(note.title)
                .font(.system(.largeTitle, design: .default, weight: .bold))
                .tracking(-0.8)
                .foregroundStyle(AppTheme.textPrimary)

            HStack(spacing: 10) {
                Text(note.createdAt, format: .dateTime.month(.wide).day().hour().minute())
                Text("•")
                Text(note.durationText)

                if note.hasRefinedNote {
                    Text("Refined")
                }
            }
            .font(.system(.subheadline, design: .default, weight: .medium))
            .foregroundStyle(AppTheme.textSecondary)
        }
    }

    private var tabs: some View {
        HStack(spacing: 24) {
            ForEach(NoteContentTab.allCases) { tab in
                Button(tab.rawValue) {
                    selectedTab = tab
                }
                .buttonStyle(.plain)
                .font(.system(.subheadline, design: .default, weight: .semibold))
                .foregroundStyle(selectedTab == tab ? AppTheme.textPrimary : AppTheme.textMuted)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(selectedTab == tab ? AppTheme.accent : .clear)
                        .frame(height: 2)
                        .offset(y: 12)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.bottom, 8)
    }

    private var bodyPanel: some View {
        ScrollView {
            Text(note.text(for: selectedTab))
                .font(.system(.title3, design: .default, weight: .regular))
                .tracking(-0.35)
                .lineSpacing(6)
                .foregroundStyle(AppTheme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .textSelection(.enabled)
                .padding(.bottom, 12)
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, minHeight: 420, alignment: .topLeading)
        .padding(24)
        .appPanelStyle()
    }
}

#Preview {
    NavigationStack {
        NoteDetailView(note: AppModelContainer.previewNote)
    }
    .modelContainer(AppModelContainer.preview)
}
