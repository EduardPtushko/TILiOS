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
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isSheetShowing = true
                    } label: {
                        Image(systemName: "plus")
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
