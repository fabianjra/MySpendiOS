//
//  TextTitleForm.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/7/23.
//

import SwiftUI

struct TextTitleForm: View {
    
    let subTitle: String
    
    var body: some View {
        VStack(spacing: Views.textSpacing) {
            Text("mySpend")
                .foregroundColor(Color.textPrimaryForeground)
                .font(Font.custom(FontFamily.thin.rawValue,
                                  size: FontSizes.bigXXL))
            
            Text(subTitle)
                .foregroundColor(Color.textPrimaryForeground)
                .font(Font.custom(FontFamily.light.rawValue,
                                  size: FontSizes.body))
        }
    }
}

struct TextTitleForm_Previews: PreviewProvider {
    static var previews: some View {
        TextTitleForm(subTitle: "Subtitle")
            .background(Color.background)
    }
}
