//
//  TextError.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 19/7/23.
//

import SwiftUI

struct TextError: View {
    
    let message: String
    
    var body: some View {
        
        Text(message)
            .foregroundColor(Color.textErrorForeground)
            .font(.montserrat(.semibold))
            .multilineTextAlignment(.center)
            .lineLimit(Views.messageMaxLines)
    }
}

struct TextError_Previews: PreviewProvider {
    static var previews: some View {

        ZStack {
            Color.background
            
            TextError(message: "Error while processing")
        }
    }
}
