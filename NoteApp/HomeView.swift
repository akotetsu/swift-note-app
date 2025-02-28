//
//  HomeView.swift
//  NoteApp
//
//  Created by 原里駆 on 2025/02/17.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    
    // SwiftDataを使用してノートをクエリ（作成日時の降順で取得）
    @Query(sort: \Note.createdAt, order: .reverse) private var notes: [Note]
    
    @State private var noteText = ""
    @State private var selectedNote: Note? = nil
    @State private var isShowingNoteEdit = false
    @State private var isNewNote = false
    @State private var searchText = ""
    
    // 検索フィルターを適用したノート一覧
    private var filteredNotes: [Note] {
        if searchText.isEmpty {
            return notes
        } else {
            return notes.filter { note in
                note.title.localizedCaseInsensitiveContains(searchText) ||
                note.content.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGray6)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    // ヘッダー
                    HStack {
                        Text("Notes")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        // 検索ボタン
                        Button {
                            withAnimation {
                                // 検索フィールドの表示切り替え
                            }
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 18))
                                .foregroundColor(.primary)
                                .frame(width: 40, height: 40)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // 検索バー
                    SearchBar(text: $searchText)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    
                    // ノート一覧
                    if filteredNotes.isEmpty {
                        ContentUnavailableView(
                            searchText.isEmpty ? "ノートがありません" : "検索結果がありません",
                            systemImage: searchText.isEmpty ? "note.text" : "magnifyingglass",
                            description: Text(searchText.isEmpty ?
                                "右下の「+」ボタンから新しいノートを作成できます" :
                                "検索条件に一致するノートがありませんでした")
                        )
                        .padding(.top, 40)
                    } else {
                        List {
                            ForEach(filteredNotes) { note in
                                NoteRow(
                                    note: note,
                                    onEdit: {
                                        selectedNote = note
                                        isNewNote = false
                                        isShowingNoteEdit = true
                                    },
                                    onDelete: {
                                        deleteNote(note)
                                    }
                                )
                                .listRowBackground(Color.white)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedNote = note
                                    isNewNote = false
                                    isShowingNoteEdit = true
                                }
                            }
                        }
                        .listStyle(.plain)
                        .background(Color(UIColor.systemGray6))
                        .padding(.top, 8)
                    }
                }
                .padding(.bottom, 20)
                
                // 新規作成用のFloatingActionButton
                Button {
                    selectedNote = nil
                    noteText = ""
                    isNewNote = true
                    isShowingNoteEdit = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.black)
                        .frame(width: 60, height: 60)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                .padding(20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }
            .navigationDestination(isPresented: $isShowingNoteEdit) {
                NoteEditView(
                    noteText: $noteText,
                    note: selectedNote,
                    isNewNote: isNewNote
                )
            }
            .navigationBarHidden(true)
        }
    }
    
    // ノート削除関数
    private func deleteNote(_ note: Note) {
        withAnimation {
            modelContext.delete(note)
            
            do {
                try modelContext.save()
            } catch {
                print("Error deleting note: \(error)")
                // エラー処理（実際のアプリではアラートなどで表示）
            }
        }
    }
}

// カスタム検索バー
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("検索", text: $text)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    // プレビュー用のモデルコンテキストとデータを作成
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Note.self, configurations: config)
    
    // サンプルデータ生成
    let modelContext = container.mainContext
    let notes = [
        Note(title: "買い物リスト", content: "1. 牛乳\n2. 卵\n3. パン\n4. バナナ"),
        Note(title: "会議メモ", content: "プロジェクトの進捗について話し合う\n- デザイン修正\n- バグ修正\n- 次回リリース日程"),
        Note(title: "アイデア", content: "新しいアプリのアイデア: カレンダーと連携するタスク管理ツール")
    ]
    
    // 日付を調整（より自然に見えるように）
    notes[0].createdAt = Date()
    notes[1].createdAt = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    notes[2].createdAt = Calendar.current.date(byAdding: .day, value: -3, to: Date())!
    
    // ノートをモデルコンテキストに追加
    for note in notes {
        modelContext.insert(note)
    }
    
    return HomeView()
        .modelContainer(container)
}

// SearchBarのプレビュー
#Preview("SearchBar") {
    struct SearchBarPreview: View {
        @State private var searchText = ""
        
        var body: some View {
            VStack(spacing: 16) {
                Text("検索バー")
                    .font(.headline)
                
                SearchBar(text: $searchText)
                    .padding()
                
                Text("検索テキスト: \(searchText)")
                    .padding()
            }
            .padding()
            .background(Color(UIColor.systemGray6))
        }
    }
    
    return SearchBarPreview()
}
