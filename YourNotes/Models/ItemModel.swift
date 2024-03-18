//
//  ItemModel.swift
//  YourNotes
//
//  Created by alexander on 2/7/24.
//

import Foundation

struct ItemModel: Identifiable, Codable, Hashable {
    var id: String
    var title: String
    var caption: String
    var flag: Bool
    
    init(id: String = UUID().uuidString, title: String, caption: String, flag: Bool) {
        self.id = id
        self.title = title
        self.caption = caption
        self.flag = flag
    }
    
    func updateCompletion() -> ItemModel {
        return ItemModel(id: id, title: title, caption: caption, flag: flag)
    }
}
