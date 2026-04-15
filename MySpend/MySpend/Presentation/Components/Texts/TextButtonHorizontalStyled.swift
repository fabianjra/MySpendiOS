//
//  TextButtonHorizontalStyled.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 22/9/24.
//

import SwiftUI

struct TextButtonHorizontalStyled: View {
    
    private let text: LocalizedStringKey
    private let table: String
    private let subTitle: LocalizedStringKey?
    private let iconLeading: Image?
    private let iconTrailing: Image?
    
    init(_ text: LocalizedStringKey = "",
         table: String = LocalizableTable.button,
         subTitle: LocalizedStringKey? = nil,
         iconLeading: Image? = nil,
         iconTrailing: Image? = nil) {
        self.text = text
        self.table = table
        self.subTitle = subTitle
        self.iconLeading = iconLeading
        self.iconTrailing = iconTrailing
    }
    
    var body: some View {
        
        HStack {
            
            if let iconLeading = iconLeading {
                iconLeading
                    .foregroundColor(Color.textPrimaryForeground)
            }
            
            
            VStack(alignment: .leading) {
                Text(text, tableName: table)
                    .font(.montserrat())
                    .foregroundColor(Color.buttonForeground)
                    .lineLimit(ConstantViews.singleTextMaxLines)
                
                if let subtitle = subTitle {
                    Text(subtitle, tableName: table)
                        .font(.montserrat(size: .small))
                        .foregroundColor(Color.textPrimaryForeground)
                        .lineLimit(ConstantViews.singleTextMaxLines)
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            if let iconTrailing = iconTrailing {
                iconTrailing
                    .foregroundColor(Color.textPrimaryForeground)
                    .padding(.trailing)
            }
        }
        .padding(.leading)
        
        // MARK: SHAPE
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        //.glassEffect(.regular.tint(Color.secondaryTop).interactive())
        .glassEffect(.regular.interactive())

    }
}

#Preview {
    VStack {
        TextButtonHorizontalStyled("Go to hitory",
                                   iconLeading: Image.stackFill,
                                   iconTrailing: Image.arrowRight)
        
        TextButtonHorizontalStyled("Go to hitory",
                                   subTitle: "Enter the history",
                                   iconLeading: Image.stackFill,
                                   iconTrailing: Image.arrowRight)
        
        TextButtonHorizontalStyled("Button only subtitle",
                                   subTitle: "this is the subtitle")
        
        TextButtonHorizontalStyled("Button without nothing",
                                   iconLeading: Image.stackFill)
        
        TextButtonHorizontalStyled("Button without nothing",
                                   iconTrailing: Image.arrowBackward)
        
        TextButtonHorizontalStyled("Button without nothing")
    }
    .padding()
    .background(Color.backgroundBottom)
}
