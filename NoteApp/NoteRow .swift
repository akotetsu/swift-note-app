//
//  NoteRow .swift
//  NoteApp
//
//  Created by 原里駆 on 2025/02/25.
//

import SwiftUI
import SwiftData

struct NoteRow: View {
    let note: Note
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(note.title)
                    .font(.headline)
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    Text(formatDate(note.updatedAt))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if Calendar.current.isDateInToday(note.createdAt) {
                        Text("今日作成")
                            .font(.caption)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
            }
            
            Spacer()
            
            Menu {
                Button(action: onEdit) {
                    Label("編集", systemImage: "pencil")
                }
                
                Button(role: .destructive, action: onDelete) {
                    Label("削除", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .frame(width: 40, height: 40)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
}

#Preview {
    // プレビュー用のモデルコンテキストとデータを作成
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Note.self, configurations: config)
    
    // サンプルデータ
    let note = Note(title: "買い物リスト", content: "1. 牛乳\n2. 卵\n3. パン\n4. バナナ")
    note.updatedAt = Date().addingTimeInterval(-3600) // 1時間前に更新
    
    return NoteRow(note: note, onEdit: {}, onDelete: {})
        .frame(width: 350)
        .padding()
        .background(Color.white)
        .modelContainer(container)
}
