//
//  TextPlain.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 1/8/23.
//

import SwiftUI

struct TextPlain: View {
    
    let message: String
    let color: Color
    let family: Font.Family
    let size: Font.Sizes
    let aligment: TextAlignment
    let lineLimit: Int
    
    init(message: String,
         color: Color = Color.textPrimaryForeground,
         family: Font.Family = .regular,
         size: Font.Sizes = .body,
         aligment: TextAlignment = .leading,
         lineLimit: Int = .max) {
        self.message = message
        self.color = color
        self.family = family
        self.size = size
        self.aligment = aligment
        self.lineLimit = lineLimit
    }
    
    var body: some View {
        Text(message)
            .foregroundColor(color)
            .font(.montserrat(family, size: size))
            .multilineTextAlignment(aligment)
            .lineLimit(lineLimit)
    }
}

#Preview {
    ZStack {
        Color.background
        
        TextPlain(message: "This is a plain message")
    }
}
