//
//  TextError.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 19/7/23.
//

import SwiftUI

struct TextError: View {
    
    private let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .foregroundColor(Color.alert)
            .font(.montserrat(.semibold))
            .multilineTextAlignment(.center)
            .lineLimit(ConstantViews.messageMaxLines)
    }
}

#Preview {
    ZStack {
        Color.backgroundBottom
        
        TextError("Error while processing")
    }
}
