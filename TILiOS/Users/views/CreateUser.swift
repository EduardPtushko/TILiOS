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
    @FocusState var focus: Field?
    
    enum Field: Hashable {
        case name
        case username
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("name", text: $name)
                        .textInputAutocapitalization(.never)
                        .focused($focus, equals: .name)
                    
                } header: {
                    Text("Name")
                }
                Section {
                    TextField("username", text: $username)
                        .textInputAutocapitalization(.never)
                        .focused($focus, equals: .username)
                } header: {
                    Text("Username")
                }
            }
            .onSubmit {
                if focus == .name {
                    focus = .username
                } else {
                    focus = nil
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .principal) {
                    
                        Text("Create User")
                            .font(.title2)
                    
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                        
                        Task {
                            await createUser()
                        }
                        dismiss()
                    } label: {
                        Text("Save")
                    }
                }
            }
            .onAppear {
                focus = .name
            }
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
