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
            
            Section(.settingsProfileSectionTitle) {
                ForEach(ProfileOptions.allCases) { option in
                    NavigationLink(destination: option.view) {
                        Label {
                            Text(option.title)
                        } icon: {
                            Text(option.icon)
                        }
                    }
                }
            }
            
            // MARK: - GENERAL
            
            Section(.settingsGeneralSectionTitle) {
                ForEach(ContentOptions.allCases) { option in
                    HStack {
                        option.icon
                        
                        NavigationLink(option.rawValue, destination: option.view)
                    }
                }
            }
            
            // MARK: - ERASE ALL DATA
            
            Section(.settingsDataSectionTitle) {
                
                Button(.settingsDataDeleteButtonTitle) {
                    showAlert = true
                }
                .foregroundColor(Color.alert)
                .fontWeight(.semibold)
                
                .alert(.settingsDataDeleteTitle, isPresented: $showAlert) {
                    
                    Button(.alertOptionCancel, role: .cancel) { }
                    
                    Button(.alertOptionDelete, role: .destructive) {
                        showAlertConfirmation = true
                    }
                } message: {
                    Text(.settingsDataDeleteDescription)
                        .textStyle
                }
                
                .alert(.settingsDataDeleteTitleConfirmation, isPresented: $showAlertConfirmation) {
                    
                    Button(.alertOptionCancel, role: .cancel) { }
                    
                    Button(.alertOptionDelete, role: .destructive) {
                        //TODO: AGREGAR BORRADO DE DATOS
                    }
                } message: {
                    Text(.settingsDataDeleteDescriptionConfirmation)
                        .textStyle
                }
            }
        }
        
        // MARK: STYLES
        .font(.montserrat())
        //.foregroundColor(Color.listRowForeground)
        //.listStyle(.insetGrouped) //Coomentend for: iOS26
        .scrollContentBackground(.hidden)
        //.background(Color.backgroundContentGradient)
        
        // MARK: NAVIGATION
        .navigationTitle(.settingsTitle) // Necesario para ver la descripcion al presionar el boton atras al navegar.
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar {
            ToolbarItem(placement: .title) {
                Text(.settingsTitle)
                    .textStyle
            }
            
            ToolbarItem(placement: .destructiveAction) {
                Button(role: .close) {
                    dismiss()
                }
            }
        }
    }
}

#Preview(Previews.localeES_ES) {
    @Previewable @State var showSettings = true
    
    VStack {
        Button(.settingsTitle) {
            showSettings.toggle()
        }
    }
    .sheet(isPresented: $showSettings) {
        NavigationStack {
            SettingsView()
        }
    }
    .environment(\.locale, .init(identifier: Previews.localeES_ES))
}
