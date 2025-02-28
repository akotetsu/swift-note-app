//
//  NoteTextView.swift
//  NoteApp
//
//  Created by 原里駆 on 2025/02/17.
//

import SwiftUI
import UIKit

struct NoteTextView: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.isScrollEnabled = true
        textView.backgroundColor = UIColor.white
        textView.layer.cornerRadius = 8
        textView.clipsToBounds = true
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        textView.text = "なにを書きますか？"
        textView.textColor = UIColor.systemGray3
        
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if !text.isEmpty {
            uiView.text = text
            uiView.textColor = UIColor.black
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        let parent: NoteTextView
        
        init(_ parent: NoteTextView) {
            self.parent = parent
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == UIColor.systemGray3 {
                textView.text = ""
                textView.textColor = UIColor.black
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = "なにを書きますか？"
                textView.textColor = UIColor.systemGray3
            }
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var text = ""
        
        var body: some View {
            VStack {
                Text("テキスト入力エリア")
                    .font(.headline)
                    .padding(.bottom, 8)
                
                NoteTextView(text: $text)
                    .frame(height: 200)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                
                Text("入力されたテキスト:")
                    .font(.headline)
                    .padding(.top, 16)
                
                Text(text.isEmpty ? "まだ何も入力されていません" : text)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(8)
            }
            .padding()
        }
    }
    
    return PreviewWrapper()
}
