//
//  SettingsView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/7/23.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var showAlert = false
    @State private var showAlertConfirmation = false
    
    @State private var selectedDateInterval = UserDefaultsManager.dateTimeInterval
    @Environment(ThemeManager.self) private var themeManager
    
    var body: some View {
        List {
            // MARK: - PROFILE
            
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
                    NavigationLink(destination: option.view) {
                        Label {
                            Text(option.title)
                        } icon: {
                            Text(option.icon)
                        }
                    }
                }
                
                
                Picker(selection: $selectedDateInterval) {
                    ForEach(DateTimeInterval.allCases) { item in
                        Text(item.localized)
                            .tag(item)
                    }
                } label: {
                    Label {
                        Text(.settingsGeneralOptionDateTimeInterval)
                    } icon: {
                        Text(verbatim: "📅")
                    }
                }
                .pickerStyle(.menu)
                .tint(.primary)
                
                
                @Bindable var themeManager = themeManager
                
                Picker(selection: $themeManager.theme) {
                    ForEach(AppTheme.allCases, id: \.self) { item in
                        Label(item.localized, systemImage: item.icon)
                            .tag(item)
                    }
                } label: {
                    Label {
                        Text(.settingsGeneralOptionAppTheme)
                    } icon: {
                        Text(verbatim: "🎨")
                    }
                }
                .pickerStyle(.menu)
                .tint(.primary)
            }
            
            // MARK: - DATA
            
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
                }
                
                .alert(.settingsDataDeleteTitleConfirmation, isPresented: $showAlertConfirmation) {
                    
                    Button(.alertOptionCancel, role: .cancel) { }
                    
                    Button(.alertOptionDelete, role: .destructive) {
                        //TODO: AGREGAR BORRADO DE DATOS
                    }
                } message: {
                    Text(.settingsDataDeleteDescriptionConfirmation)
                }
            }
        }
        .navigationTitle(.settingsTitle)
        .scrollContentBackground(.hidden)
        .background(Color.backgroundGradient)
    }
}

#Preview(Previews.localeES_ES) {
    @Previewable @State var themeManager = ThemeManager.shared
    
    NavigationStack {
        SettingsView()
    }
    .environment(themeManager)
    .preferredColorScheme(themeManager.theme.colorScheme)
    .environment(\.locale, .init(identifier: Previews.localeES_ES))
}

#Preview(Previews.localeEN) {
    @Previewable @State var themeManager = ThemeManager.shared
    
    NavigationStack {
        SettingsView()
    }
    .environment(themeManager)
    .preferredColorScheme(themeManager.theme.colorScheme)
    .environment(\.locale, .init(identifier: Previews.localeEN))
}
