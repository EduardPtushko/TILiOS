//
//  CreateCategory.swift
//  TILiOS
//
//  Created by Eduard on 29.03.2023.
//

import SwiftUI

struct CreateCategory: View {
    let requestManager = RequestManager()
    @State private var name = ""
    @Environment(\.dismiss) private var dismiss
    @FocusState var focus: Field?
    
    enum Field: Hashable {
        case name
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("name", text: $name)
                        .autocorrectionDisabled(true)
                        .focused($focus, equals: .name)
                        
                } header: {
                    Text("Category Name")
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
                    Text("Create Category")
                        .font(.title2)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || name.count >= 2 else {
                            return
                        }
                        Task {
                            await createCategory()
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
    
    private func createCategory() async  {
        do {
            let category: Category = try await requestManager.perform(CategoriesRequest.createCategory(name: name))
        } catch {
            
        }
    }
}

struct CreateCategory_Previews: PreviewProvider {
    static var previews: some View {
        CreateCategory()
    }
}
