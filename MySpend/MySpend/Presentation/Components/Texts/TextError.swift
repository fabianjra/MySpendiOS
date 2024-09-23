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
            .foregroundColor(Color.warning)
            .font(.montserrat(.semibold))
            .multilineTextAlignment(.center)
            .lineLimit(ConstantViews.messageMaxLines)
    }
}

#Preview {
    ZStack {
        Color.backgroundBottom
        
        TextError(message: "Error while processing")
    }
}
