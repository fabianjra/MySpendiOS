//
//  ResumeView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 1/8/23.
//

import SwiftUI

struct ResumeView: View {
    
    @State var userName: String = ""
    
    var body: some View {
        ContentContainer {
            
            //MARK: HEADER
            HStack {
                VStack(alignment: .leading) {
                    Text("Hello \(userName) 👋")
                        .font(.montserrat(.semibold, size: .big))
                    
                    Text("Welcome back")
                        .font(.montserrat(.light, size: .small))
                }
                .foregroundColor(Color.textPrimaryForeground)
                Spacer()
            }
            .padding(.bottom)
            
            
            //MARK: CONTENT
            VStack {
                
                Button("History") {
                    
                }
                .buttonStyle(ButtonPrimaryStyle())
            }
            .padding(.bottom)

            
            //MARK: RESUME
            ScrollView(showsIndicators: false) {
                Text("Item 1: $1000 - 25/05/2023")
                    .font(.montserrat())
                    .foregroundColor(Color.textPrimaryForeground)
            }
        }
        .onAppear { userName = "Fabian" }
    }
}

struct ResumeView_Previews: PreviewProvider {
    static var previews: some View {
        ResumeView()
    }
}
