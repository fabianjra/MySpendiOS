//
//  SettingsView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/7/23.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var showingAlert = false
    
    var body: some View {
        VStack {
            
            List(SettingsOptions.allCases) { option in
                
                HStack {
                    option.icon
                    
                    NavigationLink(option.rawValue, destination: option.view)
                        .listRowBackground(Color.textfieldBackground)
                    //.listRowSeparator(.hidden))
                }
                
            }
            //.scrollDisabled(true)
            .scrollContentBackground(.hidden)
            .background(Color.background)
            
            
            Button("Log out") {
                showingAlert = true
            }
            .buttonStyle(ButtonPrimaryStyle(color: [Color.warning]))
            .padding(.horizontal, Views.paddingSmallButton)
            .padding(.bottom, 200)
            .alert("Log out", isPresented: $showingAlert) {
                Button("OK") {
                    dismiss()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure?")
            }
            
        }
        .background(Color.background)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
