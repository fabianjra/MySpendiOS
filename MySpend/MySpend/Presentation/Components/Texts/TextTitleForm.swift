//
//  TextTitleForm.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/7/23.
//

import SwiftUI

struct TextTitleForm: View {
    
    let title: String?
    let titleWeight: Font.Family?
    let titleSize: Font.Sizes?
    let subTitle: String
    let subTitleWeight: Font.Family?
    
    init(title: String? = nil, titleWeight: Font.Family? = nil, titleSize: Font.Sizes? = nil, subTitle: String, subTitleWeight: Font.Family? = nil) {
        self.title = title
        self.titleWeight = titleWeight
        self.titleSize = titleSize
        self.subTitle = subTitle
        self.subTitleWeight = subTitleWeight
    }
    
    var body: some View {
        VStack(spacing: Views.textSpacing) {
            Text(title ?? "mySpend")
                .foregroundColor(Color.textPrimaryForeground)
                .font(.montserrat(titleWeight ?? .thin, size: titleSize ?? .bigXXL))
            
            Text(subTitle)
                .foregroundColor(Color.textPrimaryForeground)
                .font(.montserrat(subTitleWeight ?? .light))
        }
    }
}

struct TextTitleForm_Previews: PreviewProvider {
    static var previews: some View {
        TextTitleForm(subTitle: "Subtitle")
            .background(Color.background)
    }
}
