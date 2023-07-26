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
            List {
                
                //MARK: ACCOUNT
                Section {
                    ForEach(AccountOptions.allCases) { option in
                        HStack {
                            option.icon
                            
                            NavigationLink(option.rawValue, destination: option.view)
                        }
                    }
                } header: {
                    Text("Account")
                        .foregroundColor(Color.textSecondaryForeground)
                        .font(.montserrat(size: .small))
                }
                .listRowBackground(Color.textfieldBackground)
                
                //MARK: CONTENT
                Section {
                    ForEach(ContentOptions.allCases) { option in
                        HStack {
                            option.icon
                            
                            NavigationLink(option.rawValue, destination: option.view)
                        }
                    }
                } header: {
                    Text("Content")
                        .foregroundColor(Color.textSecondaryForeground)
                        .font(.montserrat(size: .small))
                }
                .listRowBackground(Color.textfieldBackground)
                
                //MARK: LOGIN
                Section {
                    Button("Log out") {
                        showingAlert = true
                    }
                    .foregroundColor(Color.warning)
                    .font(.montserrat(.semibold))
                    
                    .alert("Want to log out?", isPresented: $showingAlert) {
                        Button("Log out", role: .destructive) {
                            dismiss()
                        }
                        
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        //Text("Are you sure you want to log out?")
                    }
                    
                } header: {
                    Text("Login")
                        .foregroundColor(Color.textSecondaryForeground)
                        .font(.montserrat(size: .small))
                }
                .listRowBackground(Color.textfieldBackground)
                
            }
            .font(.montserrat())
            .foregroundColor(Color.textFieldForeground)
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.background)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
