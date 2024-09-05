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
    
    // MARK: GENERAL
    let textColor: Color
    
    // MARK: VALIDATION
    let onlyTitle: Bool
    
    init(title: String = "mySpend",
         titleWeight: Font.Family = .thin,
         titleSize: Font.Sizes = .bigXXL,
         subTitle: String = "",
         subTitleWeight: Font.Family = .light,
         subTitleSize: Font.Sizes = .body,
         textColor: Color = Color.textPrimaryForeground,
         onlyTitle: Bool = false) {
        
        self.title = title
        self.titleWeight = titleWeight
        self.titleSize = titleSize
        self.subTitle = subTitle
        self.subTitleWeight = subTitleWeight
        self.subTitleSize = subTitleSize
        self.textColor = textColor
        self.onlyTitle = onlyTitle
    }
    
    var body: some View {
        if onlyTitle {
            VStack(spacing: ConstantViews.textHeaderSpacing) {
                titleAndSubtitle
            }
        } else {
            HStack {
                ButtonNavigationBack(color: textColor) {
                    
                    //TODO: Posible solucion para remover el ultimo item del navigationPath.
                    //El problema es que no funciona cuando es Swipe to go Back, porque no se utiliza este botón.
                    //Parece que dismiss borra el ultimo item igualmente, cuando se pasa de un tab a otro, en el TabView.
//                    if Router.shared.path.count > 0 {
//                        Router.shared.path.removeLast()
//                    } else {
//                        dismiss()
//                    }
                    
                    dismiss()
                }
                    .padding(.leading)
                
                Spacer()
                
                titleAndSubtitle
                
                Spacer()
                
                ButtonNavigationBack(color: textColor) {}
                    .hidden()
                    .padding(.trailing)
            }
        }
    }
    
    private var titleAndSubtitle: some View {
        VStack(spacing: ConstantViews.textHeaderSpacing) {
            Text(title)
                .foregroundColor(textColor)
                .font(.montserrat(titleWeight, size: titleSize))
            
            Text(subTitle)
                .foregroundColor(textColor)
                .font(.montserrat(subTitleWeight, size: subTitleSize))
        }
    }
}

#Preview {
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
