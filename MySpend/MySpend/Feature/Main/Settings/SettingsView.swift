//
//  SettingsView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/7/23.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var showAlert = false
    //@EnvironmentObject var authViewModel: AuthViewModel
    
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
                
                // MARK: ERASE ALL DATA
                SectionContainer("DATA") {
                    
                    Button("Delete data") {
                        showAlert = true
                    }
                    .foregroundColor(Color.alert)
                    .font(.montserrat(.semibold))
                    
                    .alert("Want to delete all data?", isPresented: $showAlert) {
                        
                        Button("Delete", role: .destructive) {
                            do {
                                //TODO: AGREGAR BORRADO DE DATOS
                                //Router.shared.path.removeLast(Router.shared.path.count) //In case when come from register.
                            } catch {
                                Logs.CatchException(error)
                            }
                        }
                        
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("This action cannot be undone.")
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
