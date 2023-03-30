//
//  AcronymDetail.swift
//  TILiOS
//
//  Created by Eduard on 26.03.2023.
//

import SwiftUI

struct AcronymDetail: View {
    let acronym: Acronym
    @State private var short: String
    @State private var long: String
    @Environment(\.dismiss) private var dismiss
    private let requestManager = RequestManager()
    @State private var isAlertPresenting = false
    @State private var user: User? = nil
    
    init(acronym: Acronym) {
        self.acronym = acronym
        _short = State(wrappedValue: acronym.short)
        _long = State(wrappedValue: acronym.long)
        
    }
    
    var body: some View {
        Form {
            Section {
                TextField("short", text: $short)
                    .textInputAutocapitalization(.never)
                
            } header: {
                Text("Acronym")
                    .textCase(.uppercase)
            }
            
            Section {
                TextField("long", text: $long)
                    .textInputAutocapitalization(.never)
            } header: {
                Text("Meaning")
                    .textCase(.uppercase)
            }
            
            Section {
                Text(user?.username ?? "")
                   
            } header: {
                Text("User")
                    .textCase(.uppercase)
            }
            
            Section {
                List {
                    
                }
            } header: {
                Text("Categories")
                    .textCase(.uppercase)
            }
            
//            Picker() {
//
//            }
        }
        .toolbar {
            Button {
                
            } label: {
               Text("Edit")
            }
        }
        .task {
            do {
                let user: User = try await requestManager.perform(UsersRequest.getUser(userID: acronym.user.id))
                self.user = user
            } catch {
                
            }
            
        }
    }
    
    func deleteAcronym() async  {
        do {
            let acronym: Acronym =  try await requestManager.perform(AcronymIDRequest.deleteAcronym(acronymID: acronym.id!))
        } catch {
            
        }
    }
    
    func updateAcronym() async  {
        do {
            let acronym: Acronym = try await requestManager.perform(AcronymIDRequest.updateAcronym(short: short, long: long, acronymID: acronym.id!))
        } catch {
            
        }
    }
}

struct AcronymDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AcronymDetail(acronym: Acronym.mockAcronyms[0])
        }
    }
}
