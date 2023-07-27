//
//  SettingsView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/7/23.
//

import SwiftUI
import Firebase

struct SettingsView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var showingAlert = false
    
    var body: some View {
        ListContainer {
            
            //MARK: ACCOUNT
            SectionContainer(header: "Account") {
                ForEach(AccountOptions.allCases) { option in
                    HStack {
                        option.icon
                        
                        NavigationLink(option.rawValue, destination: option.view)
                    }
                }
            }
            
            //MARK: CONTENT
            SectionContainer(header: "Content") {
                ForEach(ContentOptions.allCases) { option in
                    HStack {
                        option.icon
                        
                        NavigationLink(option.rawValue, destination: option.view)
                    }
                }
            }
            
            //MARK: LOGIN
            SectionContainer(header: "Login") {
                Button("Log out") {
                    showingAlert = true
                }
                .foregroundColor(Color.warning)
                .font(.montserrat(.semibold))
                
                .alert("Want to log out?", isPresented: $showingAlert) {
                    Button("Log out", role: .destructive) {
                        
//                        let userDefaults = UserDefaults.standard
//
//                        if userDefaults.value(forKey: "appFirstTimeOpend") == nil {
//                            //if app is first time opened then it will be nil
//                            userDefaults.setValue(true, forKey: "appFirstTimeOpend")
//                            // signOut from FIRAuth
//                            do {
//                                try Auth.auth().signOut()
//                            }catch {
//
//                            }
//                            // go to beginning of app
//                        } else {
//                            //go to where you want
//                        }
                        
                        do {
                            try Auth.auth().signOut()
                            
                            dismiss()
                        } catch {
                            print("Error signing out: \(error)")
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
