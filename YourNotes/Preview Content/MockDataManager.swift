//
//  MockDataManager.swift
//  YourNotes
//
//  Created by alexander on 7.04.25.
//

import Foundation
import SwiftUI

final class MockDataManager {
    static let shared = MockDataManager()

    private init() {}

    func mockNote() -> Note {
        // Загружаем одно или несколько изображений из ресурсов
        var imagesData: [Data] = []
        
        var noteImagePaths: [String] = []

        if let image1 = UIImage(named: "sampleImage1")?.jpegData(compressionQuality: 0.8) {
            imagesData.append(image1)
        }

        if let image2 = UIImage(named: "sampleImage2")?.jpegData(compressionQuality: 0.8) {
            imagesData.append(image2)
        }
        
        if let image3 = UIImage(named: "sampleImage2")?.jpegData(compressionQuality: 0.8) {
            imagesData.append(image3)
        }

        return Note(
            noteImages: imagesData,
            title: "First note",
            subTitle: "This is first note subtitle",
            isCompleted: false,
            dateCreate: Calendar.current.date(byAdding: .year, value: -30, to: Date()) ?? Date(),
            noteImagePaths: noteImagePaths
        )
    }
}

