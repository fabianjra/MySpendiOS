//
//  SettingsView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/7/23.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var showingAlert = false
    
    var body: some View {
        ListContainer {
            
            // MARK: ACCOUNT
            SectionContainer(header: "Account") {
                ForEach(AccountOptions.allCases) { option in
                    if option.showOption {
                        HStack {
                            option.icon
                            
                            NavigationLink(option.rawValue, destination: option.view)
                        }
                    }
                }
            }
            
            // MARK: CONTENT
            SectionContainer(header: "Content") {
                ForEach(ContentOptions.allCases) { option in
                    if option.showOption {
                        HStack {
                            option.icon
                            
                            NavigationLink(option.rawValue, destination: option.view)
                        }
                    }
                }
            }
            
            // MARK: LOG OUT
            SectionContainer(header: "Login") {
                
                Button("Log out") {
                    showingAlert = true
                }
                .foregroundColor(Color.warning)
                .font(.montserrat(.semibold))
                
                .alert("Want to log out?", isPresented: $showingAlert) {
                    
                    Button("Log out", role: .destructive) {
                        do {
                            try SessionStore.singOut()
                        } catch {
                            Logs.WriteCatchExeption("Error signing out", error: error)
                        }
                    }
                    
                    Button("Cancel", role: .cancel) { }
                } message: {
                    //Text("Are you sure you want to log out?")
                }
            }
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
