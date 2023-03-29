//
//  CreateUser.swift
//  TILiOS
//
//  Created by Eduard on 27.03.2023.
//

import SwiftUI

struct CreateUser: View {
    @State private var name: String = ""
    @State private var username: String = ""
    @Environment(\.dismiss) private var dismiss
    private let requestManager = RequestManager()
    
    var body: some View {
        Form {
            Section {
                TextField("name", text: $name)
                    .textInputAutocapitalization(.never)
                
            } header: {
                Text("Name")
            }
            Section {
                TextField("username", text: $username)
                    .textInputAutocapitalization(.never)
            } header: {
                Text("Username")
            }
            
            Button {
                Task {
                    await createUser()
                }
                dismiss()
            } label: {
                Text("Add User")
            }
            .frame(maxWidth: .infinity)
            .disabled(name.isEmpty || username.isEmpty)
        }
    }
    
    private func createUser() async {
        do {
            let user: User = try await requestManager.perform(UsersRequest.createUser(name: name, username: username))
        } catch {
            
        }
    }
}

struct CreateUser_Previews: PreviewProvider {
    static var previews: some View {
        CreateUser()
    }
}
