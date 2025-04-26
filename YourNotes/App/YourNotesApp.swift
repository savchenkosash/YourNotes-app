//
//  YourNotesApp.swift
//  YourNotes
//
//  Created by alexander on 2/7/24.
//

import SwiftUI
import SwiftData
import SwiftfulRouting
 
@main
struct YourNotesApp: App {
//    let persistenceController = PersistenceController.shared
    
//    @StateObject var itemViewModel: ItemViewModel = ItemViewModel()
    
    private let container = AppContainer() // ✅ Используем новый контейнер
    
    var body: some Scene {
        WindowGroup {
            
            NavigationStack {
                ContentView()
                    .environmentObject(container.noteViewModel)   // ✅ Передаем ViewModel юзера
                    .modelContainer(container.modelContainer)    // ✅ Передаем общий SwiftData контейнер
            }
            
//            RouterView { _ in
//                ContentView()
//                    .environmentObject(container.noteViewModel)   // ✅ Передаем ViewModel юзера
//                    .modelContainer(container.modelContainer)    // ✅ Передаем общий SwiftData контейнер
//            }
        }
    }
}
