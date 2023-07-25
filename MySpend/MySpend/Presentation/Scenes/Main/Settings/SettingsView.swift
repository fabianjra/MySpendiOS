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
    case logOut = "Log out"
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .categories: Color.green
        case .changeName: Color.background
        case .changePassword: Color.blue
        case .validateAccount: Color.red
        case .logOut: Color.yellow
        }
    }
}

struct Opcion: View {
    
    let option: String
    
    var body: some View {
        Text("Opcion: \(option)")
    }
}

struct SettingsView: View {
    
    var body: some View {
        
        NavigationStack {

            List(SettingOptions.allCases, id: \.id) { option in
                
                NavigationLink(option.rawValue, value: option.rawValue)
                
                    .listRowBackground(Color.textfieldBackground)
                //.listRowSeparator(.hidden)
            }
            .navigationDestination(for: String.self, destination: Opcion.init)
            .background(Color.background)
            .scrollContentBackground(.hidden)
        }
        
        
//            NavigationStack {
//                List {
//                    NavigationLink("Show an integer", value: 42)
//                    NavigationLink("Show a string", value: "Hello, world!")
//                    NavigationLink("Show a Double", value: Double.pi)
//                }
//                .navigationDestination(for: Int.self) { Text("Received Int: \($0)") }
//                .navigationDestination(for: String.self) { Text("Received String: \($0)") }
//                .navigationDestination(for: Double.self) { Text("Received Double: \($0)") }
//                .navigationTitle("Select a value")
//            }
            
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
