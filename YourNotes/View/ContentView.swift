//
//  ContentView.swift
//  YourNotes
//
//  Created by alexander on 7.04.25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var noteViewModel: NoteViewModel
    var body: some View {
        Home()
            .environmentObject(noteViewModel)
    }
}

#Preview {
    let container = AppContainer()
    return ContentView()
        .environmentObject(container.noteViewModel)
}
