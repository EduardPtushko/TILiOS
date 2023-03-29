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
    @State private var isShowing = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(users) { user in
                    VStack(alignment: .leading){
                        Text(user.name)
                    }
                }
            }
            .toolbar {
                Button {
                    isShowing = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .fullScreenCover(isPresented: $isShowing, onDismiss: {
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
