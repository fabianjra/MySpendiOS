//
//  TextNeutral.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 19/7/23.
//

import SwiftUI

struct TextNeutral: View {
    
    let text: String
    let color: Color = Color.textPrimaryForeground
    let font: FontFamily = .regular
    //let size: Font = .body
    
    var body: some View {
        
        Text(text)
            .foregroundColor(color)
//            .font(.custom(font.rawValue,
//                              size: size))
    }
}

struct TextNeutral_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack {
            Color.background
            
            TextNeutral(text: "Neutral text")
        }
    }
}
