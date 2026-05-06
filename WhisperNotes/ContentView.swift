//
//  ContentView.swift
//  WhisperNotes
//
//  Created by Никита Сторчай on 01.05.2026.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    var body: some View {
        AppShellView()
            .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
        .modelContainer(AppModelContainer.preview)
}
