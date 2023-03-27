//
//  AcronymDetail.swift
//  TILiOS
//
//  Created by Eduard on 26.03.2023.
//

import SwiftUI

struct AcronymDetail: View {
    let acronym: Acronym
    @State private var short: String = ""
    @State private var long: String = ""
    @Environment(\.dismiss) private var dismiss
    private let requestManager = RequestManager()
    @State private var isAlertPresenting = false
    
    var body: some View {
        Form {
            Section {
                TextField("short", text: $short)
                    .textInputAutocapitalization(.never)
                
            } header: {
                Text("Short form")
            }
            
            Section {
                TextField("long", text: $long)
                    .textInputAutocapitalization(.never)
            } header: {
                Text("Long form")
            }
            HStack {
                Button {
                    Task {
                        await updateAcronym()
                    }
                    dismiss()
                } label: {
                    Text("Update")
                }
                .frame(maxWidth: .infinity)
                .disabled(short.isEmpty || long.isEmpty)
                Spacer()
                Button {
                    isAlertPresenting = true
                    //                    Task {
                    //                        await deleteAcronym()
                    //                    }
                    //                    dismiss()
                } label: {
                    Text("Delete")
                        .foregroundColor(.red)
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(BorderlessButtonStyle())
            
        }
        .confirmationDialog("Are you sure?",
                            isPresented: $isAlertPresenting) {
            Button("Delete this Acronym?", role: .destructive) {
                Task {
                    await deleteAcronym()
                }
                dismiss()
            }
        }
        .onAppear {
            short = acronym.short
            long = acronym.long
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
        AcronymDetail(acronym: Acronym.mockAcronyms[0])
    }
}
