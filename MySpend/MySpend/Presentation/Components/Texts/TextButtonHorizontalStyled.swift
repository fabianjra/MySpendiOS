//
//  TextButtonHorizontalStyled.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 22/9/24.
//

import SwiftUI

struct TextButtonHorizontalStyled: View {
    
    private let text: LocalizedStringKey
    private let subTitle: LocalizedStringKey
    private let color: Array<Color>
    private let iconLeading: Image?
    private let iconTrailing: Image?
    
    init(_ text: LocalizedStringKey = "",
         color: Array<Color> = Color.secondaryGradiant,
         subTitle: LocalizedStringKey = "",
         iconLeading: Image? = nil,
         iconTrailing: Image? = nil) {
        self.text = text
        self.subTitle = subTitle
        self.color = color
        self.iconLeading = iconLeading
        self.iconTrailing = iconTrailing
    }
    
    var body: some View {
        
        HStack {
            
            if let iconLeading = iconLeading {
                iconLeading
                    .foregroundColor(Color.textPrimaryForeground)
                    .padding()
                    .background(
                        LinearGradient(colors: Color.primaryGradiant,
                                       startPoint: .top,
                                       endPoint: .bottom)
                    )
                    .clipShape(Circle())
            }
            
            
            VStack(alignment: .leading) {
                Text(text)
                    .font(.montserrat(size: .big))
                    .foregroundColor(Color.buttonForeground)
                    .lineLimit(ConstantViews.singleTextMaxLines)
                
                Text(subTitle)
                    .font(.montserrat(size: .small))
                    .foregroundColor(Color.textFieldPlaceholder)
                    .lineLimit(ConstantViews.singleTextMaxLines)
            }
            .padding(.horizontal)
            
            
            Spacer()
            
            if let iconTrailing = iconTrailing {
                iconTrailing
                    .foregroundColor(Color.textPrimaryForeground)
                    .padding()
                    .padding(.trailing)
            }
        }
        .padding(.leading)
        
        // MARK: SHAPE
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        .background(LinearGradient(colors: color,
                                   startPoint: .top,
                                   endPoint: .bottom))
        .cornerRadius(ConstantRadius.corners)
    }
}

#Preview {
    VStack {
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
