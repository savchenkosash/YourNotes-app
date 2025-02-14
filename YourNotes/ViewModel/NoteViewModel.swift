//
//  NoteViewModel.swift
//  YourNotes
//
//  Created by alexander on 7.04.25.
//

import SwiftData
import Foundation

class NoteViewModel: ObservableObject {
    @Published var note: Note?
    @Published var allNotes: [Note] = []

    private let noteService: NoteServiceProtocol

    var service: NoteServiceProtocol { noteService }

    init(noteService: NoteServiceProtocol) {
        self.noteService = noteService
        loadAllNotes()
    }

    // 🔍 Загрузка конкретной заметки по `noteID`
    func loadNote(by id: String) {
        self.note = noteService.fetchNote(by: id)
    }

    // 🔍 Загрузка всех заметок
    func loadAllNotes() {
        self.allNotes = noteService.fetchAllNotes()
    }

    // 💾 Создание новой заметки
    func createNote(title: String, subTitle: String, imageData: Data? = nil, isCompleted: Bool = false) {
        let newNote = Note(noteImage: imageData, title: title, subTitle: subTitle, isCompleted: isCompleted)
        noteService.createNote(newNote)
        loadAllNotes()
        print("✅ Новая заметка создана.")
    }

    // ✏️ Обновление данных существующей заметки
    func updateNote(title: String, subTitle: String, imageData: Data? = nil, isCompleted: Bool = false) {
        guard let note = note else { return }

        note.title = title
        note.subTitle = subTitle
        note.noteImage = imageData
        note.isCompleted = isCompleted

        noteService.updateNote(by: note.noteID, with: note)
        
        // 🔥 Загружаем обновлённую версию заметки
        loadNote(by: note.noteID)
        loadAllNotes()
        print("✅ Заметка обновлена.")
    }

    // 🗑 Удаление заметки
    func deleteNote(by id: String) {
        noteService.deleteNote(by: id)
        loadAllNotes()
        print("✅ Заметка удалена.")
    }
}
