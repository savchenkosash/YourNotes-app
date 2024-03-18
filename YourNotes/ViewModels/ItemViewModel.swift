//
//  ItemViewModel.swift
//  YourNotes
//
//  Created by alexander on 2/7/24.
//

import Foundation

class ItemViewModel: ObservableObject {
    
    @Published var items: [ItemModel] = [] {
        didSet {
            saveItems()
        }
    }
    
    @Published var filteredArray: [ItemModel] = []
    @Published var favoritesArray: [ItemModel] = []
    
    @Published var filterTextField: String = ""
    
    let itemsKey: String = "items_list"

    init() {
        getItems()
        updateFilteredArray()
    }
    
    func disableFilter() {
        filterTextField = ""
    }

    func getItems() {
        guard
            let data = UserDefaults.standard.data(forKey: itemsKey),
            let savedItems = try? JSONDecoder().decode([ItemModel].self, from: data)
        else { return }
            self.items = savedItems
    }
    
    func updateItem(item: ItemModel) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item.updateCompletion()
        }
    }
    
    func saveItems() {
        if let encodedData = try? JSONEncoder().encode(items) {
            UserDefaults.standard.setValue(encodedData, forKey: itemsKey)
        }
    }
    
//    func updateFilteredArrayByName() {
//        sortedArray = items.sorted(by: { (title1, title2) -> Bool in
//            return title1.title < title2.title
//        })
//    }
    
    func updateFilteredArrayByName() {
        items = items.sorted(by: { $0.title < $1.title })
        
//
//        items = items.sorted(by: { (title1, title2) -> Bool in
//            return title1.title > title2.title
//        })
    }
    
    func updateFavoritesArray() {
        favoritesArray = items.filter({ (picker) -> Bool in
            return picker.flag
        })
    }
    
    func updateFilteredArray() {
        filteredArray = items.filter({ $0.title.localizedLowercase.contains(filterTextField.lowercased()) || $0.caption.localizedLowercase.contains(filterTextField.lowercased()) })
        
//          FULL SAMPLE CODE
//        filteredArray = items.filter({ (symbol) -> Bool in
//            return symbol.title.lowercased().contains(filterTextField.lowercased())
//            return symbol.title.localizedLowercase.contains(filterTextField.lowercased())
//    })
    }
    
    func addItem(title: String, caption: String, flag: Bool) {
        let newItem = ItemModel(title: title, caption: caption, flag: flag)
        items.append(newItem)
    }
    
    func editItem(id: String, title: String, caption: String) {
        if let editedItem = items.first(where: { $0.id == id }) {
            let index = items.firstIndex(of: editedItem)
            
            items[index ?? 0].title = title
            items[index ?? 0].caption = caption
        }
    }
    
    func removeItem(at index: Int) {
        items.remove(at: index)
    }

    
//    func removeItem(indexSet: IndexSet) {
//        items.remove(atOffsets: indexSet)
//    }
    
    
}
    





