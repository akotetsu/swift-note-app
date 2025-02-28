//
//  NoteAppApp.swift
//  NoteApp
//
//  Created by 原里駆 on 2025/02/17.
//

import SwiftUI
import SwiftData

@main
struct NoteAppApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: Note.self, isUndoEnabled: true)
    }
}
