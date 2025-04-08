//
//  NoteService.swift
//  YourNotes
//
//  Created by alexander on 7.04.25.
//

import Foundation
import SwiftData

enum NoteFactory {
    static func createNoteService(context: ModelContext) -> NoteServiceProtocol {
        #if DEBUG
        print("🛠 Используется MockUserService (DEBUG)")
        return MockNoteService()
        #else
        print("🚀 Используется UserService (RELEASE)")
        return NoteService(context: context)
        #endif
    }
}

// MARK: - Protocol
protocol NoteServiceProtocol {
    func fetchNote(by id: String) -> Note?  /// Получает заметку по `noteID`
    func fetchAllNotes() -> [Note] /// Получает все заметки, отсортированные по дате создания (от новых к старым)
    func createNote(_ note: Note) /// Создаёт новую заметку
    func updateNote(by id: String, with newNote: Note) /// Обновляет существующую заметку по `noteID`
    func deleteNote(by id: String) /// Удаляет заметку по `noteID`
}

// MARK: - SWIFTDATA Service
final class NoteService: NoteServiceProtocol {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    /// Получает заметку по `noteID`
    func fetchNote(by id: String) -> Note? {
        do {
            let descriptor = FetchDescriptor<Note>(predicate: #Predicate { $0.noteID == id })
            let notes = try context.fetch(descriptor)
            return notes.first
        } catch {
            print("⚠️ Ошибка при загрузке заметки по ID: \(error.localizedDescription)")
            return nil
        }
    }

    /// Получает все заметки, отсортированные по дате создания (от новых к старым)
    func fetchAllNotes() -> [Note] {
        do {
            let descriptor = FetchDescriptor<Note>(sortBy: [SortDescriptor(\.dateCreate, order: .reverse)])
            return try context.fetch(descriptor)
        } catch {
            print("⚠️ Ошибка при загрузке всех заметок: \(error.localizedDescription)")
            return []
        }
    }

    /// Создаёт новую заметку
    func createNote(_ note: Note) {
        context.insert(note)
        do {
            try context.save()
            print("✅ Заметка успешно создана.")
        } catch {
            print("⚠️ Ошибка при создании заметки: \(error.localizedDescription)")
        }
    }

    /// Обновляет существующую заметку по `noteID`
    func updateNote(by id: String, with newNote: Note) {
        guard let existingNote = fetchNote(by: id) else {
            print("⚠️ Заметка с ID \(id) не найдена.")
            return
        }

        existingNote.noteImage = newNote.noteImage
        existingNote.title = newNote.title
        existingNote.subTitle = newNote.subTitle
        existingNote.isCompleted = newNote.isCompleted
        existingNote.dateCreate = newNote.dateCreate

        do {
            try context.save()
            print("✅ Заметка успешно обновлена.")
        } catch {
            print("⚠️ Ошибка при обновлении заметки: \(error.localizedDescription)")
        }
    }

    /// Удаляет заметку по `noteID`
    func deleteNote(by id: String) {
        guard let note = fetchNote(by: id) else {
            print("⚠️ Заметка с ID \(id) не найдена.")
            return
        }
        context.delete(note)
        do {
            try context.save()
            print("✅ Заметка успешно удалена.")
        } catch {
            print("⚠️ Ошибка при удалении заметки: \(error.localizedDescription)")
        }
    }
}


// MARK: - Mock User Service
final class MockNoteService: NoteServiceProtocol {
    private var mockNotes: [Note] = []

    init() {
        // Добавляем одну тестовую заметку для примера
        self.mockNotes = [MockDataManager.shared.mockNote()]
    }

    /// Получает заметку по `noteID`
    func fetchNote(by id: String) -> Note? {
        return mockNotes.first(where: { $0.noteID == id })
    }

    /// Получает все заметки, отсортированные по дате создания (от новых к старым)
    func fetchAllNotes() -> [Note] {
        return mockNotes.sorted(by: { $0.dateCreate > $1.dateCreate })
    }

    /// Создаёт новую заметку
    func createNote(_ note: Note) {
        mockNotes.append(note)
        print("✅ (Mock) Заметка создана.")
    }

    /// Обновляет существующую заметку по `noteID`
    func updateNote(by id: String, with newNote: Note) {
        if let index = mockNotes.firstIndex(where: { $0.noteID == id }) {
            mockNotes[index] = newNote
            print("✅ (Mock) Заметка обновлена.")
        } else {
            print("⚠️ (Mock) Заметка с ID \(id) не найдена, создаем новую.")
            createNote(newNote)
        }
    }

    /// Удаляет заметку по `noteID`
    func deleteNote(by id: String) {
        if let index = mockNotes.firstIndex(where: { $0.noteID == id }) {
            mockNotes.remove(at: index)
            print("✅ (Mock) Заметка удалена.")
        } else {
            print("⚠️ (Mock) Заметка с ID \(id) не найдена.")
        }
    }
}
