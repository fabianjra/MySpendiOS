//
//  SettingsView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/7/23.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var showAlert = false
    @State private var showAlertConfirmation = false
    
    var body: some View {
        List {
            // MARK: - ACCOUNT
            
            SectionContainer("Profile") {
                ForEach(AccountOptions.allCases) { option in
                    if option.showOption {
                        HStack {
                            option.icon
                            
                            NavigationLink(option.rawValue, destination: option.view)
                        }
                    }
                }
            }
            
            // MARK: - CONTENT
            
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
            
            // MARK: - ERASE ALL DATA
            
            SectionContainer("Data") {
                
                Button("Delete data") {
                    showAlert = true
                }
                .foregroundColor(Color.alert)
                .font(.montserrat(.semibold))
                
                .alert("Want to delete all data?", isPresented: $showAlert) {
                    
                    Button("Delete", role: .destructive) {
                        showAlertConfirmation = true
                    }
                    
                    Button("Cancel", role: .cancel) { }
                } message: {
                    TextPlain("This action cannot be undone.")
                }
                
                .alert("Are you completely sure you want to delete all data?", isPresented: $showAlertConfirmation) {
                    
                    Button("Delete", role: .destructive) {
                        //TODO: AGREGAR BORRADO DE DATOS
                    }
                    
                    Button("Cancel", role: .cancel) { }
                } message: {
                    TextPlain("All accounts, categories and transactions will be permanently deleted.")
                }
            }
        }
        
        // MARK: STYLES
        .font(.montserrat())
        .foregroundColor(Color.listRowForeground)
        //.listStyle(.insetGrouped) //Coomentend for: iOS26
        .scrollContentBackground(.hidden)
        //.contentMargins(.top, ConstantViews.mediumSpacing) //Coomentend for: iOS26
        .background(Color.backgroundContentGradient)
        
        // MARK: NAVIGATION
        .navigationTitle("Settings") // Necesario para ver la descripcion al presionar el boton atras al navegar.
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar {
            
            ToolbarItem(placement: .title) {
                TextPlain("Settings")
            }
            
            ToolbarItem(placement: .destructiveAction) {
                Button(role: .close) {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
