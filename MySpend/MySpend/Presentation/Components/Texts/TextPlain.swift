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
    let truncateMode: Text.TruncationMode
    
    init(message: String,
         color: Color = Color.textPrimaryForeground,
         family: Font.Family = .regular,
         size: Font.Sizes = .body,
         aligment: TextAlignment = .leading,
         lineLimit: Int = ConstantViews.singleTextMaxLines,
         truncateMode: Text.TruncationMode = .tail) {
        self.message = message
        self.color = color
        self.family = family
        self.size = size
        self.aligment = aligment
        self.lineLimit = lineLimit
        self.truncateMode = truncateMode
    }
    
    var body: some View {
        Text(message)
            .foregroundColor(color)
            .font(.montserrat(family, size: size))
            .multilineTextAlignment(aligment)
            .truncationMode(truncateMode)
            .lineLimit(lineLimit)
    }
}

#Preview {
    VStack {
        Spacer()
        
        TextPlain(message: "This is a plain message")
            .padding()
        
        TextPlain(message: "This is a plain message asdf asf asf asdf asdf asf  fasdf asdf asdf",
                  lineLimit: 1,
                  truncateMode: .middle)
        .padding()
        
        TextPlain(message: "This is a plain message")
            .padding()
        
        Spacer()
    }
    .background(Color.backgroundBottom)
}
