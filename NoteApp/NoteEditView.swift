//
//  NoteEditView.swift
//  NoteApp
//
//  Created by 原里駆 on 2025/02/18.
//
import SwiftUI
import SwiftData

struct NoteEditView: View {
    @Binding var noteText: String
    var note: Note?
    var isNewNote: Bool
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var isSaving = false
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            // ノートテキスト入力領域
            NoteTextView(text: $noteText)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                .focused($isTextFieldFocused)
            
            // 保存ボタン
            Button(action: saveNote) {
                HStack {
                    if isSaving {
                        ProgressView()
                            .tint(.black)
                            .padding(.trailing, 4)
                    }
                    
                    Text("保存")
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(noteText.isEmpty ? Color.gray.opacity(0.3) : Color.white)
                .foregroundColor(noteText.isEmpty ? .gray : .black)
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            }
            .disabled(noteText.isEmpty || isSaving)
        }
        .padding(20)
        .navigationTitle(isNewNote ? "新規ノート" : "編集")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemGray6).ignoresSafeArea())
        .onAppear {
            if let note = note, noteText.isEmpty {
                noteText = note.content
            }
            
            // キーボードを自動的に表示
            isTextFieldFocused = true
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !isNewNote {
                    ShareLink(
                        item: noteText,
                        subject: Text(note?.title ?? "ノートを共有"),
                        message: Text("ノートアプリから共有")
                    ) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .disabled(noteText.isEmpty)
                }
            }
        }
    }
    
    private func saveNote() {
        guard !noteText.isEmpty else { return }
        
        isSaving = true
        
        // 保存処理を少し遅延させて視覚的なフィードバックを与える
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if isNewNote {
                let newNote = Note(content: noteText)
                newNote.update(content: noteText)
                modelContext.insert(newNote)
            } else if let note = note {
                note.update(content: noteText)
            }
            
            do {
                try modelContext.save()
                noteText = ""
                isSaving = false
                dismiss()
            } catch {
                print("Error saving note: \(error)")
                isSaving = false
                // エラー処理（実際のアプリではアラートなどで表示）
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var text = "これはテスト用のノート内容です。\n新しい行も表示されます。"
        
        var body: some View {
            NavigationStack {
                // 編集モードのプレビュー
                NoteEditView(
                    noteText: $text,
                    note: nil,
                    isNewNote: false
                )
            }
        }
    }
    
    // プレビュー用のモデルコンテキストを準備
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Note.self, configurations: config)
    
    return PreviewWrapper()
        .modelContainer(container)
}
