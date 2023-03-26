//
//  ContentView.swift
//  TILiOS
//
//  Created by Eduard on 26.03.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
           AcronymsView()
                .tabItem {
                    VStack {
                        Image(systemName: "abc")
                        Text("Acronyms")
                    }
                }
            
            UsersView()
                .tabItem {
                    VStack {
                       Image(systemName: "person.3")
                        Text("Users")
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

