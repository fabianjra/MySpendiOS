//
//  SettingsView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/7/23.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var showAlert = false
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ContentContainer(addPading: false) {
            ListContainer {
                
                // MARK: ACCOUNT
                SectionContainer("Account") {
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
                SectionContainer("Content") {
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
                SectionContainer("Login") {
                    
                    Button("Log out") {
                        showAlert = true
                    }
                    .foregroundColor(Color.alert)
                    .font(.montserrat(.semibold))
                    
                    .alert("Want to log out?", isPresented: $showAlert) {
                        
                        Button("Log out", role: .destructive) {
                            do {
                                authViewModel.cleanSession()
                                
                                try AuthFB().singOut()
                                Router.shared.path.removeLast(Router.shared.path.count) //In case when come from register.
                            } catch {
                                Logs.CatchException(error)
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
}

#Preview {
    SettingsView()
}
