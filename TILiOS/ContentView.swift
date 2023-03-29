//
//  ContentView.swift
//  TILiOS
//
//  Created by Eduard on 26.03.2023.
//

import SwiftUI

struct ContentView: View {
    @SceneStorage("selectedView") var selectedView: String?
    
    var body: some View {
        TabView(selection: $selectedView) {
           AcronymsView()
                .tag(AcronymsView.tag)
                .tabItem {
                    VStack {
                        Image(systemName: "abc")
                        Text("Acronyms")
                    }
                }
            
            UsersView()
                .tag(UsersView.tag)
                .tabItem {
                    VStack {
                       Image(systemName: "person.2")
                        Text("Users")
                    }
                }
            
            CategoriesView()
                .tag(CategoriesView.tag)
                .tabItem {
                    VStack {
                        Image(systemName: "doc.plaintext")
                        Text("Categories")
                    }
                }
            
           
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

