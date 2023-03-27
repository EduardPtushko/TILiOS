//
//  AcronymsView.swift
//  TILiOS
//
//  Created by Eduard on 26.03.2023.
//

import SwiftUI

struct AcronymsView: View {
    @State private var acronyms: [Acronym] = []
    @State private var isLoading = true
    private let requestManager = RequestManager()
    @State private var isSheetShowing = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(acronyms) { acronym in
                    NavigationLink(value: acronym) {
                        HStack {
                            Text(acronym.short)
                            Spacer()
                            Text(acronym.long)
                        }
                    }
                    
                }
            }
            .navigationDestination(for: Acronym.self, destination: { acronym in
                AcronymDetail(acronym: acronym)
            })
            .navigationTitle("Acronyms")
            .listStyle(.plain)
            .task {
                await fetchAcronyms()
            }
            .overlay {
                if isLoading {
                    ProgressView("Loading...")
                }
            }
            .toolbar {
                Button {
                    isSheetShowing = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $isSheetShowing, onDismiss: {
                Task {
                    await fetchAcronyms()
                }
            }) {
                CreateAcronymView()
            }
        }
    }
    
    private  func delete(indexSet: IndexSet) async {
        
    }
    
    private func fetchAcronyms() async  {
        do {
            let acronyms: [Acronym] = try await requestManager.perform(AcronymsRequest.getAcronyms)
            self.acronyms = acronyms
            await stopLoading()
        } catch {
            
        }
    }
    
    func stopLoading() async  {
        isLoading = false
    }
}

struct AcronymsView_Previews: PreviewProvider {
    static var previews: some View {
        AcronymsView()
    }
}
