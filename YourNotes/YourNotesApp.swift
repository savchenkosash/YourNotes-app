//
//  YourNotesApp.swift
//  YourNotes
//
//  Created by alexander on 2/7/24.
//

import SwiftUI

@main
struct YourNotesApp: App {
//    let persistenceController = PersistenceController.shared
    
    @StateObject var itemViewModel: ItemViewModel = ItemViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView()
            }
            .environmentObject(itemViewModel)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
