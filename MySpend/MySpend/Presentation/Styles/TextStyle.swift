//
//  TextStyle.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 31/7/26.
//

import SwiftUI

private struct TextStyle: ViewModifier {
    
    let color: Color
    let family: Font.Family
    let size: Font.Sizes
    let aligment: TextAlignment
    let lineLimit: Int
    let truncateMode: Text.TruncationMode
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(color)
            .font(.montserrat(family, size: size))
            .multilineTextAlignment(aligment)
            .truncationMode(truncateMode)
            .lineLimit(lineLimit)
    }
}

extension Text {
    
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
    
    var textStyle: some View {
        self.textStyle()
    }
    
    var textErrorStyle: some View {
        self.modifier(TextStyle(color: .alert,
                                family: .semibold,
                                size: .body,
                                aligment: .center,
                                lineLimit: ConstantViews.messageMaxLines,
                                truncateMode: .tail))
    }
}

#Preview {
    VStack {
        Spacer()
        
        Text("MySpend app para transferencias")
            .textStyle
            .padding()
        
        Text("This is a plain message asdf asf asf asdf asdf asf  fasdf asdf asdf")
            .textStyle(color: .primaryTop,
                       family: .thin,
                       size: .bigXXL,
                       aligment: .trailing,
                       lineLimit: 1,
                       truncateMode: .middle)
            .padding()
        
        Text("This is an error message")
            .textErrorStyle
            .padding()
        
        Spacer()
    }
    .background(Color.backgroundBottom)
}
