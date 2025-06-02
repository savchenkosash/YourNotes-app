//
//  NoteService.swift
//  YourNotes
//
//  Created by alexander on 7.04.25.
//

// NoteService.swift
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

protocol NoteServiceProtocol {
    func fetchNote(by id: String) -> Note?  /// Получает заметку по `noteID`
    func fetchAllNotes() -> [Note] /// Получает все заметки, отсортированные по дате создания (от новых к старым)
    func createNote(_ note: Note) /// Создаёт новую заметку
    func updateNote(by id: String, with newNote: Note) /// Обновляет существующую заметку по `noteID`
    func deleteNote(by id: String) /// Удаляет заметку по `noteID`
}

final class NoteService: NoteServiceProtocol {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

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

    func fetchAllNotes() -> [Note] {
        do {
            let descriptor = FetchDescriptor<Note>(sortBy: [SortDescriptor(\.dateCreate, order: .reverse)])
            return try context.fetch(descriptor)
        } catch {
            print("⚠️ Ошибка при загрузке всех заметок: \(error.localizedDescription)")
            return []
        }
    }

    func createNote(_ note: Note) {
        context.insert(note)
        do {
            try context.save()
            print("✅ Заметка успешно создана.")
        } catch {
            print("⚠️ Ошибка при создании заметки: \(error.localizedDescription)")
        }
    }

    func updateNote(by id: String, with newNote: Note) {
        guard let existingNote = fetchNote(by: id) else {
            print("⚠️ Заметка с ID \(id) не найдена.")
            return
        }
        
        // Вот тут надо:
        // 1. Удалить файлы из existingNote.noteImagePaths, которых нет в newNote.noteImagePaths
        // 2. Сохранить новые данные

        // Для удаления:
        let oldPaths = existingNote.noteImagePaths
        let newPaths = newNote.noteImagePaths

        // Удаляем файлы, которых нет в новых путях
        for oldPath in oldPaths {
            if !newPaths.contains(oldPath) {
                ImageFileManager.deleteImage(filename: oldPath)
            }
        }
        
        existingNote.noteImages = newNote.noteImages
        existingNote.title = newNote.title
        existingNote.subTitle = newNote.subTitle
        existingNote.isCompleted = newNote.isCompleted
        existingNote.dateCreate = newNote.dateCreate
        existingNote.noteImagePaths = newNote.noteImagePaths

        do {
            try context.save()
            print("✅ Заметка успешно обновлена.")
        } catch {
            print("⚠️ Ошибка при обновлении заметки: \(error.localizedDescription)")
        }
    }

    func deleteNote(by id: String) {
        guard let note = fetchNote(by: id) else {
            print("⚠️ Заметка с ID \(id) не найдена.")
            return
        }
        
        // Удаляем все изображения из файловой системы
        for filename in note.noteImagePaths {
            ImageFileManager.deleteImage(filename: filename)
            print("Удалены файлы изображений \(filename)")
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

// Mock сервис для отладки
final class MockNoteService: NoteServiceProtocol {
    private var mockNotes: [Note] = []

    init() {
        self.mockNotes = [MockDataManager.shared.mockNote()]
    }

    func fetchNote(by id: String) -> Note? {
        return mockNotes.first(where: { $0.noteID == id })
    }

    func fetchAllNotes() -> [Note] {
        return mockNotes.sorted(by: { $0.dateCreate > $1.dateCreate })
    }

    func createNote(_ note: Note) {
        mockNotes.append(note)
        print("✅ (Mock) Заметка создана.")
    }

    func updateNote(by id: String, with newNote: Note) {
        if let index = mockNotes.firstIndex(where: { $0.noteID == id }) {
            mockNotes[index] = newNote
            print("✅ (Mock) Заметка обновлена.")
        } else {
            print("⚠️ (Mock) Заметка с ID \(id) не найдена, создаем новую.")
            createNote(newNote)
        }
    }

    func deleteNote(by id: String) {
        if let index = mockNotes.firstIndex(where: { $0.noteID == id }) {
            mockNotes.remove(at: index)
            print("✅ (Mock) Заметка удалена.")
        } else {
            print("⚠️ (Mock) Заметка с ID \(id) не найдена.")
        }
    }
}
