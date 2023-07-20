//
//  TextStyleButton.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/7/23.
//

import SwiftUI

struct TextViewStyledButton: View {
    
    let text: String

    var body: some View {
        
        Text(text)
            //Font family
            .font(.custom(FontFamily.regular.rawValue, size: FontSizes.body))
            .foregroundColor(Color.buttonForeground)
        
            //Button shape
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .background(LinearGradient(colors: Color.primaryGradiant,
                                       startPoint: .leading,
                                       endPoint: .trailing))
            .cornerRadius(Radius.buttonCorners)
    }
}

struct TextViewStyledButton_Previews: PreviewProvider {
    static var previews: some View {
        TextViewStyledButton(text: "Button style")
    }
}
