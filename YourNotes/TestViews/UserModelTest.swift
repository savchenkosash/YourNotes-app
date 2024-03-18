//
//  UserModelTest.swift
//  YourNotes
//
//  Created by alexander on 2/13/24.
//

import SwiftUI

struct UserModel: Identifiable, Hashable {
        let id: String = UUID().uuidString
        let name: String
        let lastName: String
        var textFieldVar: String
    }


class ArrayVM: ObservableObject {
    
    @Published var dataArray: [UserModel] = []
    @Published var filteredArray: [UserModel] = []
    @Published var filterTextField: String = ""
    
    init() {
        getUsers()
        updateFilteredArray()
    }
    
    func updateFilteredArray() {
        filteredArray = dataArray.filter({ (user) -> Bool in
            return user.name.contains(filterTextField)
        })
    }
    
    func getUsers() {
        let user1 = UserModel(name: "Nick", lastName: "Sarno", textFieldVar: "No")
        let user2 = UserModel(name: "Steve", lastName: "Sarno", textFieldVar: "Yes")
        let user3 = UserModel(name: "Alex", lastName: "Sarno", textFieldVar: "No")
        self.dataArray.append(contentsOf: [user1, user2, user3])
    }
}

struct UserModelTest: View {
    
//    @StateObject var vm = ArrayVM()
    @EnvironmentObject var vm: ArrayVM
    
    var body: some View {
        VStack {
            
            TextField("Your text", text: $vm.filterTextField)
                .onChange(of: vm.filterTextField, perform: { value in
                    vm.updateFilteredArray()
                })
            
            Button(action: {
                vm.dataArray.append(UserModel(name: "1", lastName: "ln", textFieldVar: "str"))
            }, label: {
                Text("Add")
            })
           
            ForEach(vm.filteredArray) { user in
                Text(user.name)
                }
            
            if vm.filteredArray.isEmpty {
                ForEach(vm.dataArray) { user in
                    Text(user.name)
                    }
            }
            }
        }
    }


struct UserModelTest_Previews: PreviewProvider {
    static var previews: some View {
        UserModelTest()
            .environmentObject(ArrayVM())
    } 
}
