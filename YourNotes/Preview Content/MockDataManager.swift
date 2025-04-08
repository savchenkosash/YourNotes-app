//
//  MockDataManager.swift
//  YourNotes
//
//  Created by alexander on 7.04.25.
//

import Foundation
import SwiftUI
// import UIKit


final class MockDataManager {
    static let shared = MockDataManager()

    private init() {}

    func mockNote() -> Note {
           let image = UIImage(named: "nullProfile")?.jpegData(compressionQuality: 0.8)

        return Note(
            noteImage: image,
            title: "First note",
            subTitle: "This is first note subtitle",
            isCompleted: false,
            dateCreate: Calendar.current.date(byAdding: .year, value: -30, to: Date()) ?? Date()
       )
    }
}
