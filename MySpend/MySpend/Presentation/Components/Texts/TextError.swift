//
//  TextError.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 19/7/23.
//

import SwiftUI

struct TextError: View {
    
    @Binding var message: String
    
    var body: some View {
        
        Text(message)
            .modifier(Show(isVisible: !message.isEmpty))
            .foregroundColor(Color.textErrorForeground)
            .font(.custom(FontFamily.semibold.rawValue, size: FontSizes.body))
            .multilineTextAlignment(.center)
            .lineLimit(Views.messageMaxLines)
    }
}

struct TextError_Previews: PreviewProvider {
    static var previews: some View {

        ZStack {
            Color.background
            
            TextError(message: .constant("Error while processing"))
        }
    }
}
