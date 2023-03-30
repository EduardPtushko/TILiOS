//
//  UsersView.swift
//  TILiOS
//
//  Created by Eduard on 26.03.2023.
//

import SwiftUI

struct UsersView: View {
    static let tag: String? = "Users"
    @State private var users: [User] = []
    private var requestManager = RequestManager()
    @State private var hasError = false
    @State private var isSheetShowing = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(users) { user in
                    VStack(alignment: .leading){
                        Text(user.name)
                    }
                }
                .onDelete { indexSet in
                    Task {
                        try await withThrowingTaskGroup(of: User.self, body: { group in
                            for index in indexSet {
                                guard let userID = users[index].id else {
                                    fatalError("Out of range")
                                }
                                group.addTask {
                                    try await requestManager.perform(UsersRequest.deleteUser(userID: userID))
                                }
                            }
                        })
                    }
                }
            }
            .toolbar {
                Button {
                    withAnimation {
                        isSheetShowing = true
                    }
                } label: {
                    Label("Add Category",systemImage: "plus")
                }
            }
            .fullScreenCover(isPresented: $isSheetShowing, onDismiss: {
                Task {
                    
                    await fetchUsers()
                }
            }) {
                CreateUser()
            }
            .task {
                await fetchUsers()
            }
        }
    }
    
    private func fetchUsers() async {
        do {
            let users: [User] =  try await requestManager.perform(UsersRequest.getAllUser)
            self.users = users
        } catch  {
            hasError = true
        }
    }
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        UsersView()
    }
}
