//
//  Note.swift
//  NoteApp
//
//  Created by 原里駆 on 2025/02/25.
//

import Foundation
import SwiftData

@Model
final class Note {
    var id: UUID
    var title: String
    var content: String
    var createdAt: Date
    var updatedAt: Date

    init(id: UUID = UUID(), title: String = "新規ノート", content: String = "", createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = createdAt // 初期作成時は作成日と更新日は同じ
    }
    
    func update(content: String) {
        self.content = content
        self.updatedAt = Date()
        self.title = generateTitle(from: content)
    }
    
    private func generateTitle(from content: String) -> String {
        let firstLine = content.split(separator: "\n").first ?? ""
        if firstLine.isEmpty {
            let preview = String(content.prefix(15))
            return preview.isEmpty ? "新規ノート" : preview
        }
        return String(firstLine)
    }
}
