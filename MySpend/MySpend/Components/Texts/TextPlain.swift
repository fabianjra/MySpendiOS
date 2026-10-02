//
//  TextPlain.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 1/8/23.
//

import SwiftUI

struct TextPlain: View {
    
    private let text: String
    private let color: Color
    private let family: Font.Family
    private let size: Font.Sizes
    private let aligment: TextAlignment
    private let lineLimit: Int
    private let truncateMode: Text.TruncationMode
    
    init(_ text: String,
         color: Color = Color.textPrimaryForeground,
         family: Font.Family = Font.Family.regular,
         size: Font.Sizes = Font.Sizes.body,
         aligment: TextAlignment = TextAlignment.leading,
         lineLimit: Int = ConstantViews.singleTextMaxLines,
         truncateMode: Text.TruncationMode = Text.TruncationMode.tail) {
        self.text = text
        self.color = color
        self.family = family
        self.size = size
        self.aligment = aligment
        self.lineLimit = lineLimit
        self.truncateMode = truncateMode
    }
    
    var body: some View {
        Text(text)
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
        
        TextPlain("This is a plain message")
            .padding()
        
        TextPlain("This is a plain message asdf asf asf asdf asdf asf  fasdf asdf asdf",
                  lineLimit: 1,
                  truncateMode: .middle)
        .padding()
        
        TextPlain("This is a plain message")
            .padding()
        
        Spacer()
    }
    .background(Color.backgroundBottom)
}
