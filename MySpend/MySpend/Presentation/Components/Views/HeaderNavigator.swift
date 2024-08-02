//
//  HeaderNavigator.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/23.
//

import SwiftUI

struct HeaderNavigator: View {
    
    @Environment(\.dismiss) private var dismiss
    
    // MARK: TITLE
    let title: String
    let titleWeight: Font.Family
    let titleSize: Font.Sizes
    
    // MARK: SUBTITLE
    let subTitle: String
    let subTitleWeight: Font.Family
    let subTitleSize: Font.Sizes
    
    // MARK: VALIDATION
    let onlyTitle: Bool
    
    init(title: String = "mySpend",
         titleWeight: Font.Family = .thin,
         titleSize: Font.Sizes = .bigXXL,
         subTitle: String = "",
         subTitleWeight: Font.Family = .light,
         subTitleSize: Font.Sizes = .body,
         onlyTitle: Bool = false) {
        
        self.title = title
        self.titleWeight = titleWeight
        self.titleSize = titleSize
        self.subTitle = subTitle
        self.subTitleWeight = subTitleWeight
        self.subTitleSize = subTitleSize
        self.onlyTitle = onlyTitle
    }
    
    var body: some View {
        if onlyTitle {
            VStack(spacing: ConstantViews.textHeaderSpacing) {
                titleAndSubtitle
            }
        } else {
            HStack {
                ButtonNavigationBack { dismiss() }
                    .padding(.leading)
                
                Spacer()
                
                titleAndSubtitle
                
                Spacer()
                
                ButtonNavigationBack {}
                    .hidden()
                    .padding(.trailing)
            }
        }
    }
    
    private var titleAndSubtitle: some View {
        VStack(spacing: ConstantViews.textHeaderSpacing) {
            Text(title)
                .foregroundColor(Color.textPrimaryForeground)
                .font(.montserrat(titleWeight, size: titleSize))
            
            Text(subTitle)
                .foregroundColor(Color.textPrimaryForeground)
                .font(.montserrat(subTitleWeight, size: subTitleSize))
        }
    }
}

struct HeaderNavigator_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HeaderNavigator(title: "Title",
                            titleWeight: .thin,
                            titleSize: .bigXXL,
                            subTitle: "Subtitle",
                            subTitleWeight: .light,
                            subTitleSize: .body)
            
            DividerView()
            
            HeaderNavigator(title: "Only title",
                            subTitle: "Only Subtitle",
                            onlyTitle: true)
        }
        .background(Color.background)
    }
}
