//
//  AcronymsView.swift
//  TILiOS
//
//  Created by Eduard on 26.03.2023.
//

import SwiftUI

struct AcronymsView: View {
    static let tag: String? = "Acronyms"
    @State private var acronyms: [Acronym] = []
    @State private var isLoading = true
    private let requestManager = RequestManager()
    @State private var isSheetShowing = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(acronyms) { acronym in
                    NavigationLink {
                        AcronymDetail(acronym: acronym)
                    } label: {
                        HStack {
                            Text(acronym.short)
                            Spacer()
                            Text(acronym.long)
                        }
                    }
                }
            }
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
            .fullScreenCover(isPresented: $isSheetShowing, onDismiss: {
                Task {
                    await fetchAcronyms()
                }
            }) {
                CreateAcronymView()
            }
        }
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
