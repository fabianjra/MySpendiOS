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
    
    @Environment(DateTimeIntervalManager.self) private var dateTimeIntervalManager
    @Environment(ThemeManager.self) private var themeManager
    
    //TODO: Cambiar por environment
    @State private var selectedCurrencyDescription = CurrencyManager.selectedSymbolOrCode
    
    @AppStorage(UserDefaultsKeys.showCents.rawValue,
                store: UserDefaultsManager.userDefaults)
    private var showCents = true
    
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
            
            Section(.settingsContentSectionTitle) {
                
                ForEach(ContentOptions.allCases) { option in
                    NavigationLink(destination: option.view) {
                        Label {
                            Text(option.title)
                        } icon: {
                            Text(option.icon)
                        }
                    }
                }
            }
            
            // MARK: - USER INTERFACE
            
            Section {
                ForEach(UserInterfaceOptions.allCases) { option in
                    NavigationLink(destination: option.view) {
                        HStack {
                            Label {
                                Text(option.title)
                            } icon: {
                                Text(option.icon)
                            }
                            
                            Spacer()
                            
                            Text(verbatim: selectedCurrencyDescription)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .alignmentGuide(.listRowSeparatorLeading) { dimensions in
                        dimensions[.leading]
                    }
                }
                
                
                Toggle(isOn: $showCents) {
                    Label {
                        Text(.currencyShowCents)
                    } icon: {
                        Text(verbatim: "🪙")
                    }
                }
                .tint(.accentColor)
                
                
                @Bindable var themeManager = themeManager
                
                Picker(selection: $themeManager.theme) {
                    ForEach(AppTheme.allCases, id: \.self) { item in
                        Label(item.localized, systemImage: item.icon)
                            .tag(item)
                    }
                } label: {
                    Label {
                        Text(.settingsOptionAppTheme)
                    } icon: {
                        Text(verbatim: "🎨")
                    }
                }
                .pickerStyle(.menu)
                .tint(.secondary)
                
                @Bindable var dateTimeIntervalManager = dateTimeIntervalManager
                
                Picker(selection: $dateTimeIntervalManager.defaultInterval) {
                    ForEach(DateTimeInterval.allCases) { item in
                        Text(item.localized)
                            .tag(item)
                    }
                } label: {
                    Label {
                        Text(.settingsOptionDateInterval)
                    } icon: {
                        Text(verbatim: "📅")
                    }
                }
                .pickerStyle(.menu)
                .tint(.secondary)
                
            }
            header: {
                Text(.settingsUserInterfaceSectionTitle)
                
            } footer: {
                Text(.settingsOptionDateIntervalFooter)
            }
            
            // MARK: - DATA
            
            Section(.settingsDataSectionTitle) {
                
                Button(.settingsDataDeleteButtonTitle) {
                    showAlert = true
                }
                .foregroundColor(Color.alert)
                .fontWeight(.semibold)
            }
            .listSectionSpacing(.custom(ConstantViews.paddingMedium))
            
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
        .navigationTitle(.settingsTitle)
        .scrollContentBackground(.hidden)
        .background(Color.backgroundGradient)
        
        //TODO: Cambiar por environment
        .onAppear {
            selectedCurrencyDescription = CurrencyManager.selectedSymbolOrCode
        }
    }
}

#Preview(Previews.localeES_ES) {
    @Previewable @State var dateIntervalManager = DateTimeIntervalManager.shared
    @Previewable @State var themeManager = ThemeManager.shared
    
    NavigationStack {
        SettingsView()
    }
    .environment(dateIntervalManager)
    .environment(themeManager)
    .preferredColorScheme(themeManager.theme.colorScheme)
    .environment(\.locale, .init(identifier: Previews.localeES_ES))
}

#Preview(Previews.localeEN) {
    @Previewable @State var dateIntervalManager = DateTimeIntervalManager.shared
    @Previewable @State var themeManager = ThemeManager.shared
    
    NavigationStack {
        SettingsView()
    }
    .environment(dateIntervalManager)
    .environment(themeManager)
    .preferredColorScheme(themeManager.theme.colorScheme)
    .environment(\.locale, .init(identifier: Previews.localeEN))
}
