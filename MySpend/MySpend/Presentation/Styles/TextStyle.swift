//
//  TextStyle.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 31/7/26.
//

import SwiftUI

private struct TextStyle: ViewModifier {
    
    private let color: Color
    private let family: Font.Family
    private let size: Font.Sizes
    private let aligment: TextAlignment
    private let lineLimit: Int
    private let truncateMode: Text.TruncationMode
    
    init(color: Color,
         family: Font.Family,
         size: Font.Sizes,
         aligment: TextAlignment,
         lineLimit: Int,
         truncateMode: Text.TruncationMode) {
        
        self.color = color
        self.family = family
        self.size = size
        self.aligment = aligment
        self.lineLimit = lineLimit
        self.truncateMode = truncateMode
    }
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(color)
            .font(.montserrat(family, size: size))
            .multilineTextAlignment(aligment)
            .truncationMode(truncateMode)
            .lineLimit(lineLimit)
    }
}

extension View {
    func textStyle(color: Color = Color.textPrimaryForeground,
                   family: Font.Family = Font.Family.regular,
                   size: Font.Sizes = Font.Sizes.body,
                   aligment: TextAlignment = TextAlignment.leading,
                   lineLimit: Int = ConstantViews.singleTextMaxLines,
                   truncateMode: Text.TruncationMode = Text.TruncationMode.tail) -> some View {
        
        self.modifier(TextStyle(color: color,
                                family: family,
                                size: size,
                                aligment: aligment,
                                lineLimit: lineLimit,
                                truncateMode: truncateMode))
    }
}

#Preview {
    VStack {
        Spacer()
        
        Text("MySpend app para transferencias")
            .textStyle()
            .padding()
        
        Text("This is a plain message asdf asf asf asdf asdf asf  fasdf asdf asdf")
            .textStyle(lineLimit: 1, truncateMode: .middle)
            .padding()
        
        Text("This is a plain message")
            .textStyle()
            .padding()
        
        Spacer()
    }
    .background(Color.backgroundBottom)
}
