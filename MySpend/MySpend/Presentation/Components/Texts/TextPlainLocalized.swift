//
//  TextPlainLocalized.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/7/25.
//

import SwiftUI

struct TextPlainLocalized: View {
    
    private let text: LocalizedStringKey
    private let color: Color
    private let family: Font.Family
    private let size: Font.Sizes
    private let aligment: TextAlignment
    private let lineLimit: Int
    private let truncateMode: Text.TruncationMode
    
    init(_ text: LocalizedStringKey,
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

#Preview("es") {
    VStack {
        Spacer()
        
        TextPlainLocalized("This is a plain message without localized key")
            .padding()
        
        TextPlainLocalized("large text large text large text large text large text large text",
                  lineLimit: 2,
                  truncateMode: .middle)
        .padding()
        
        TextPlainLocalized("onboarding.title")
            .padding()
            
        Spacer()
    }
    .background(Color.backgroundBottom)
    .environment(\.locale, .init(identifier: "es"))
}

#Preview("en") {
    VStack {
        TextPlainLocalized("onboarding.title")
            .padding()
    }
    .background(Color.backgroundBottom)
    .environment(\.locale, .init(identifier: "en"))
}
