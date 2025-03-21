NoteApp

SwiftUI を用いて作成されたシンプルなノートアプリです。新規ノートの作成、ノートの編集・削除などの機能を備えています。

機能概要
	•	ノート一覧表示
登録されているノートを一覧で表示します。日付やタイトルの確認が可能です。
	•	ノート新規作成
新規ノートのタイトルや内容を入力し、保存できます。
	•	ノート編集
既存のノートを編集して保存し直すことができます。
	•	ノート削除
不要になったノートを一覧画面や編集画面などから削除可能です。

主要画面
	•	HomeView.swift
アプリ起動時のメイン画面です。ノートの一覧を表示し、新規作成や詳細画面への遷移を管理します。
	•	NoteRow.swift
ノート一覧表示用の行を定義するための View です。ノートのタイトルや日付などを表示します。
	•	NoteEditView.swift
ノートの新規作成・編集用の View です。タイトルや本文を入力し、保存ボタンでデータを更新します。
	•	NoteTextView.swift
SwiftUI の標準 TextEditor を拡張して使いやすくしたテキスト入力領域を提供する View です。
	•	NoteAppApp.swift
アプリのエントリーポイントです。SwiftUI アプリ全体を起動し、環境設定を行います。
	•	Note.swift
ノートを管理するモデルです。タイトルや本文、作成日などをプロパティとして持っています。

環境
	•	Xcode 13 以降 (推奨)
	•	iOS 15 以降 (推奨)
	•	Swift 5.5 以降
