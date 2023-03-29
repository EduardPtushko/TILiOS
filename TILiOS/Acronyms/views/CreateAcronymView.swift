//
//  CreateAcronymView.swift
//  Acronyms
//
//  Created by Eduard on 25.03.2023.
//

import SwiftUI

struct CreateAcronymView: View {
    @State private var short: String = ""
    @State private var long: String = ""
    @State private var selectedUsername: String = ""
    @State private var usernames: [String] = []
    @Environment(\.dismiss) private var dismiss
    private let requestManager = RequestManager()
    @FocusState var focus: Field?
    @State private var users: [User] = []
    
    enum Field: Hashable {
        case short
        case long
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Short version of the acronym", text: $short)
                        .focused($focus, equals: .short)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    
                } header: {
                    Text("Acronym")
                        .textCase(.uppercase)
                }
                
                Section {
                    TextField("Meaning of the acronym", text: $long)
                        .focused($focus, equals: .long)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                } header: {
                    Text("Meaning")
                        .textCase(.uppercase)
                }

                
                Picker("User", selection: $selectedUsername) {
                    ForEach(usernames, id: \.self) { username in
                        Text(username)
                    }
                }
                .pickerStyle(.menu)
                
                
            }
            .onSubmit {
                if focus == .short {
                    focus = .long
                } else {
                    focus = nil
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Create Acronym")
                        .font(.title2)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        guard !short.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !long.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                        Task {
                            await createAcronym()
                        }
                        dismiss()
                    } label: {
                        Text("Save")
                    }
                }
            }
            .onAppear {
                focus = .short
            }
            .task {
                await getAllUsers()
            }
        }
    }
    
  private  func createAcronym() async  {
        do {
            guard  let selectedUserID = self.users.first(where: { $0.username == selectedUsername})?.id else {
                return
            }
           
            
            let acronym: Acronym = try await requestManager.perform(AcronymsRequest.createAcronym(short: short, long: long, userID: selectedUserID))
        } catch {
            
        }
    }
    
    private func getAllUsers() async  {
        do {
            let users: [User] = try await requestManager.perform(UsersRequest.getAllUser)
            self.users = users
            self.usernames = users.map { $0.username}
            
        } catch {
            
        }
    }
    
}

struct CreateAcronymView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAcronymView()
    }
}
