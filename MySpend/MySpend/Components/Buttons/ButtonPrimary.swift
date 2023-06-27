//
//  ButtonPrimary.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/6/23.
//

import SwiftUI

struct ButtonPrimary: View {
    
    let text: String
    let function: () -> Void
    
    var body: some View {
        Button {
            function()
        } label: {
            Text(text)
                .foregroundColor(Color.buttonForeground)
                .font(Font.custom(FontFamily.regular.rawValue,
                                  size: FontSizes.body))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        .background(LinearGradient(colors: Color.primaryGradiant,
                                   startPoint: .leading,
                                   endPoint: .trailing))
        .clipShape(RoundedRectangle(cornerRadius: Radius.buttonCorners))
    }
}

struct ButtonPrimary_Previews: PreviewProvider {
    static var previews: some View {
        ButtonPrimary(text: "Button Primary", function: { print("hola") })
    }
}
