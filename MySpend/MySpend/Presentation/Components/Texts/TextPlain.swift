//
//  TextPlain.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 1/8/23.
//

import SwiftUI

struct TextPlain: View {
    
    var message: String
    var color: Color = Color.textPrimaryForeground
    var family: Font.Family = .regular
    var size: Font.Sizes = .body
    var aligment: TextAlignment = .leading
    var lineLimit: Int = ConstantViews.singleTextMaxLines
    var truncateMode: Text.TruncationMode = .tail
    
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
