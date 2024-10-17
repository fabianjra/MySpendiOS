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
    let showLeadingAction: Bool
    
    // MARK: RIGHT ACTION (to dimiss by default)
    let showTrailingAction: Bool
    let trailingImage: Image
    let trailingAction: (() -> Void)? //Optional because dont need to excecute everytime this view is called.
    
    init(title: String = "mySpend",
         titleWeight: Font.Family = .thin,
         titleSize: Font.Sizes = .bigXXL,
         subTitle: String = "",
         subTitleWeight: Font.Family = .light,
         subTitleSize: Font.Sizes = .body,
         textColor: Color = Color.textPrimaryForeground,
         onlyTitle: Bool = false,
         showLeadingAction: Bool = true,
         showTrailingAction: Bool = false,
         trailingImage: Image = Image.xmarkCircle,
         trailingAction: (() -> Void)? = nil) {
        
        self.title = title
        self.titleWeight = titleWeight
        self.titleSize = titleSize
        self.subTitle = subTitle
        self.subTitleWeight = subTitleWeight
        self.subTitleSize = subTitleSize
        self.textColor = textColor
        self.onlyTitle = onlyTitle
        self.showLeadingAction = showLeadingAction
        self.showTrailingAction = showTrailingAction
        self.trailingImage = trailingImage
        self.trailingAction = trailingAction
    }
    
    var body: some View {
        if onlyTitle {
            titleAndSubtitle
        } else {
            HStack {
                ButtonNavigation(tintColor: textColor) {
                    
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
                .modifier(Show(isVisible: showLeadingAction))
                .padding(.leading)
                
                Spacer()
                
                titleAndSubtitle
                
                Spacer()
                
                ButtonNavigation(image: trailingImage, tintColor: textColor) { trailingAction?() }
                    .modifier(Show(isVisible: showTrailingAction))
                    .padding(.trailing)
            }
        }
    }
    
    private var titleAndSubtitle: some View {
        VStack(spacing: ConstantViews.textHeaderSpacing) {
            TextPlain(message: title,
                      color: textColor,
                      family: titleWeight,
                      size: titleSize,
                      aligment: .center,
                      lineLimit: ConstantViews.singleTextMaxLines,
                      truncateMode: .middle)
            
            TextPlain(message: subTitle,
                      color: textColor,
                      family: subTitleWeight,
                      size: subTitleSize,
                      aligment: .center,
                      lineLimit: ConstantViews.singleTextMaxLines,
                      truncateMode: .middle)
        }
    }
}

#Preview("Navigation header") {
    VStack {
        HeaderNavigator(title: "Title",
                        titleWeight: .thin,
                        titleSize: .bigXXL,
                        subTitle: "Subtitle",
                        subTitleWeight: .light,
                        subTitleSize: .body)
        
        DividerView()
        
        HeaderNavigator(title: "Title and close",
                        subTitle: "Press right button to close",
                        showTrailingAction: true)
        
        DividerView()
        
        HeaderNavigator(title: "Only close",
                        subTitle: "Press right button to close",
                        showLeadingAction: false,
                        showTrailingAction: true)
        
        DividerView()
        
        HeaderNavigator(title: "Truncated text because its too large to show entirely",
                        subTitle: "truncated subtitle because its too large to show entirely",
                        showTrailingAction: true)
        
        DividerView()
        
        HeaderNavigator(title: "Only title",
                        subTitle: "Only Subtitle",
                        onlyTitle: true)
    }
    .background(Color.backgroundBottom)
}
