//
//  SettingsView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/7/23.
//

import SwiftUI

enum SettingOptions: String, CaseIterable, Identifiable, Hashable {
    public var id: Self { self }
    case categories = "Categories"
    case changeName = "Change my name"
    case changePassword = "Change my password"
    case validateAccount = "Validate account"
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .categories: Color.green
        case .changeName: Color.background
        case .changePassword: Color.blue
        case .validateAccount: Color.red
        }
    }
}

struct Opcion: View {
    
    let option: String
    
    var body: some View {
        VStack {
            Text("Opcion: \(option)")
        }
    }
}

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            List(SettingOptions.allCases, id: \.id) { option in
                
                NavigationLink(option.rawValue, destination: {
                    option.view
                        .toolbar(.hidden)
                })
                .listRowBackground(Color.textfieldBackground)
                //.listRowSeparator(.hidden))
            }
            .background(Color.background)
            .scrollContentBackground(.hidden)
            
            Button("Log out") {
                dismiss()
            }
            .buttonStyle(ButtonPrimaryStyle(color: [Color.warning]))
            .padding(.horizontal, Views.paddingSmallButton)
            .padding(.bottom, 200)
        }
        .background(Color.background)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
