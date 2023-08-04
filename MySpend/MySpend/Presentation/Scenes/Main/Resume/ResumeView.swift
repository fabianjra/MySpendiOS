//
//  ResumeView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 1/8/23.
//

import SwiftUI
import Firebase

struct ResumeView: View {
    
    @State var userName: String = ""
    
    var body: some View {
        ContentContainer {
            
            // MARK: HEADER
            HStack {
                VStack(alignment: .leading) {
                    Text("Hello \(userName) \(Emojis.greeting)")
                        .font(.montserrat(.semibold, size: .big))
                        .lineLimit(Views.messageMaxLines)
                    
                    Text("Welcome back")
                        .font(.montserrat(.light, size: .small))
                }
                .foregroundColor(Color.textPrimaryForeground)
                Spacer()
            }
            .padding(.bottom)
            
            
            // MARK: CONTENT
            VStack {
                
                Button("History") {
                    
                }
                .buttonStyle(ButtonPrimaryStyle())
            }
            .padding(.bottom)

            
            // MARK: RESUME
            ScrollView(showsIndicators: false) {
                Text("Item 1: $1000 - 25/05/2023")
                    .font(.montserrat())
                    .foregroundColor(Color.textPrimaryForeground)
            }
        }
        .onAppear {
            
            if let user = SessionStore.getCurrentUser() {
                
                // The user's ID, unique to the Firebase project.
                // Do NOT use this value to authenticate with your backend server,
                // if you have one. Use getTokenWithCompletion:completion: instead.
                
                let _: String = user.providerID
                let _: String = user.uid
                let displayName: String? = user.displayName
                let _: URL? = user.photoURL
                let _: String? = user.email
                
                var multiFactorString = "MultiFactor: "
                for info in user.multiFactor.enrolledFactors {
                  multiFactorString += info.displayName ?? "[DispayName]"
                  multiFactorString += " "
                }
                
                userName = displayName ?? ""
            }
        }
    }
}

struct ResumeView_Previews: PreviewProvider {
    static var previews: some View {
        ResumeView()
    }
}
