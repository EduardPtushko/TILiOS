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
    @State private var categories: [Category] = []
    @State private var acronymCategories: [Category] = []
    @State private var isEditSheetShowing = false
    
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
                List(acronymCategories) { category in
                    Text(category.name)
                }
            } header: {
                Text("Categories")
                    .textCase(.uppercase)
            }

            Section {
                NavigationLink("Add Category") {
                    AddCategoryView(categories: categories, id: acronym.id)
                }
            }
        }
        .toolbar {
            Button {
                isEditSheetShowing = true
            } label: {
               Text("Edit")
            }
        }
        .fullScreenCover(isPresented: $isEditSheetShowing){
            EditAcronymView()
        }
        .task {
            do {
                async let categoriesResult: [Category] = requestManager.perform(CategoriesRequest.getAllCategories)
                async let userResult: User =  requestManager.perform(UsersRequest.getUser(userID: acronym.user.id))
                
                guard let acronymID = acronym.id else { fatalError() }
                
                async let acronymCategoriesResult: [Category] = requestManager.perform(AcronymIDRequest.getAcronymCategories(acronymID: acronymID))
                
                let (categories, user, acronymCategories) = try await (categoriesResult, userResult, acronymCategoriesResult)
                
                self.categories = categories
                self.user = user
                self.acronymCategories = acronymCategories
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

struct AddCategoryView: View {
    let categories: [Category]
    let id: UUID?
   
    var body: some View {
        List {
            ForEach(categories) { category in
                AddCategoryRowView(category: category, id: id)
            }
        }
//        .task {
//            do {
//                let categories: [Category] = try await requestManager.perform(CategoriesRequest.getAllCategories)
//
//                self.categories = categories
//
//            } catch {
//
//            }
//        }
        
        
    }
}

struct AddCategoryRowView: View {
    @State private var isOn = false
    let category: Category
    let id: UUID?
    private let requestManager = RequestManager()
    
    var body: some View {
        HStack {
            Text(category.name)
            Spacer()
//            Toggle(isOn: $isOn) {
//                Text("")
//            }
//            .toggleStyle(iOSCheckboxToggleStyle())
            Image(systemName: isOn ? "checkmark" : "")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isOn.toggle()
                Task {
                    do {
                        guard let acronymID = id, let categoryID = category.id else {
                            fatalError()
                        }
                        if isOn {
                            let _: Int =
                            try await requestManager.perform(AcronymIDRequest.addAcronymToCategory(acronymID: acronymID, categoryID: categoryID))
                        } else {
                            let _: Int =
                            try await requestManager.perform(AcronymIDRequest.removeAcronymFromCategory(acronymID: acronymID, categoryID: categoryID))
                        }
                    } catch {
                        
                    }
                }
           
              
            
        }
        
    }
}

struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")

                configuration.label
            }
        })
    }
}


