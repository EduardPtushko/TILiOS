//
//  CategoriesView.swift
//  TILiOS
//
//  Created by Eduard on 27.03.2023.
//

import SwiftUI

struct CategoriesView: View {
    static let tag: String? = "Categories"
    
    let requestManager = RequestManager()
    @State private var categories: [Category] = []
    @State private var isSheetShowing = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(categories) { category in
                    Text(category.name)
                }
                .onDelete { indexSet in
                    Task {
                        try await withThrowingTaskGroup(of: Category.self, body: { group in
                            for index in indexSet {
                                guard let categoryID = categories[index].id else {
                                    fatalError("Out of range")
                                }
                                group.addTask {
                                    try await requestManager.perform(CategoriesRequest.deleteCategory(categoryID: categoryID))
                                }
                            }
                        })
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            isSheetShowing = true
                        }
                    } label: {
                        Label("Add Category",systemImage: "plus")
                    }
                }
            }
            .fullScreenCover(isPresented: $isSheetShowing, onDismiss: {
                Task {
                    await fetchCategories()
                }
            }, content: {
                CreateCategory()
            })
            .task {
                await fetchCategories()
        }
        }
    }
    
    private func fetchCategories() async  {
        do {
            let categories: [Category] = try await requestManager.perform(CategoriesRequest.getAllCategories)
            self.categories = categories
        } catch {
            
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}
