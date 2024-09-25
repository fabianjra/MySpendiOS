//
//  TextButtonHorizontalStyled.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 22/9/24.
//

import SwiftUI

struct TextButtonHorizontalStyled: View {
    
    private let text: String
    private let subTitle: String
    private let color: Array<Color>
    private let iconLeading: Image?
    private let iconTrailing: Image?
    
    init(text: String = "",
         color: Array<Color> = Color.secondaryGradiant,
         subTitle: String = "",
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
                    .lineLimit(ConstantViews.buttonMaxLines)
                
                Text(subTitle)
                    .font(.montserrat(size: .small))
                    .foregroundColor(Color.textFieldPlaceholder)
                    .lineLimit(ConstantViews.buttonMaxLines)
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
        TextButtonHorizontalStyled(text:"Go to hitory",
                                   subTitle: "Enter the history",
                                   iconLeading: Image.stackFill,
                                   iconTrailing: Image.arrowRight)
        
        TextButtonHorizontalStyled(text:"Button only subtitle",
                                   subTitle: "this is the subtitle")
        
        TextButtonHorizontalStyled(text: "Button without nothing",
                                   iconLeading: Image.stackFill)
        
        TextButtonHorizontalStyled(text: "Button without nothing",
                                   iconTrailing: Image.arrowBackward)
        
        TextButtonHorizontalStyled(text: "Button without nothing")
    }
    .padding()
    .background(Color.backgroundBottom)
}