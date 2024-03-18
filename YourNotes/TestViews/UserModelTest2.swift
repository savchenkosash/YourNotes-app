//
//  UserModelTest2.swift
//  YourNotes
//
//  Created by alexander on 3/4/24.
//

import SwiftUI

struct userModel1: Hashable, Identifiable {
    let id: String = UUID().uuidString
    let name: String
    let lastName: String
}



struct UserModelTest2: View {
    
    @State var userModel_view: [userModel1] = [
        userModel1(name: "Alex", lastName: "Savchenko"),
        userModel1(name: "Alex2", lastName: "Savchenko2"),
        userModel1(name: "Alex2", lastName: "Savchenko3")
        ]
    
    var body: some View {
        VStack {
            ForEach (userModel_view, id: \.self) { user in
                Text(user.name)
            }
        }
    }
}

struct UserModelTest2_Previews: PreviewProvider {
    static var previews: some View {
        UserModelTest2()
    }
}
