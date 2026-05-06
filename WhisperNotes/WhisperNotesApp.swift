//
//  WhisperNotesApp.swift
//  WhisperNotes
//
//  Created by Никита Сторчай on 01.05.2026.
//

import SwiftData
import SwiftUI

@main
@MainActor
struct WhisperNotesApp: App {
    private let modelContainer = AppModelContainer.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
