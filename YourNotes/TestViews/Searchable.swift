//
//  Searchable.swift
//  YourNotes
//
//  Created by alexander on 2/15/24.
//

import SwiftUI

struct Searchable: View {
    
    
    @EnvironmentObject var itemViewModel: ItemViewModel
    
    @State var data: [String] = ["Apple", "Juice", "Orange"]
    @State var searchText: String = ""
    
    var body: some View {
        ScrollView {
            TextField("Search...", text: $searchText)
                .padding()
            ForEach(data.filter({ "\($0)".contains(searchText) || searchText.isEmpty }), id: \.self) { num in
                HStack {
                    Text("\(num)")
                        .padding()
                    Spacer()
                }
                Divider()
            }
        }
    }
}

struct Searchable_Previews: PreviewProvider {
    static var previews: some View {
        Searchable()
    }
}
