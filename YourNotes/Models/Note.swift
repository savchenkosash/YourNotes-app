//
//  Note.swift
//  YourNotes
//
//  Created by alexander on 7.04.25.
//

import Foundation
import SwiftData

@Model
class Note {
    private(set) var noteID: String = UUID().uuidString
    var noteImage: Data?
    var title: String
    var subTitle: String
    var isCompleted: Bool
    var dateCreate: Date
    
    init(noteImage: Data? = nil, title: String, subTitle: String, isCompleted: Bool, dateCreate: Date = .now) {
        self.noteImage = noteImage
        self.title = title
        self.subTitle = subTitle
        self.isCompleted = isCompleted
        self.dateCreate = dateCreate
    }
}
