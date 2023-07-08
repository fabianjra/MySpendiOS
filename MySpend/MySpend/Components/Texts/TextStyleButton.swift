//
//  TextStyleButton.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/7/23.
//

import SwiftUI

struct TextStyleButton: View {
    
    private var text: String = ""
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        
        Text(text)
            //Font family
            .font(Font.custom(FontFamily.regular.rawValue, size: FontSizes.body))
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

struct TextStyleButton_Previews: PreviewProvider {
    static var previews: some View {
        TextStyleButton("Button style")
    }
}
