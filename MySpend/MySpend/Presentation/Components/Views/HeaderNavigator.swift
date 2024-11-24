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
    var title: String = "mySpend"
    var titleWeight: Font.Family = .thin
    var titleSize: Font.Sizes = .bigXXL
    
    // MARK: SUBTITLE
    var subTitle: String = ""
    var subTitleWeight: Font.Family = .light
    var subTitleSize: Font.Sizes = .body
    
    // MARK: GENERAL
    var textColor: Color = Color.textPrimaryForeground
    
    // MARK: VALIDATION
    var onlyTitle: Bool = false
    var showLeadingAction: Bool = true
    
    // MARK: RIGHT ACTION (to dimiss by default)
    var showTrailingAction: Bool = false
    var trailingImage: Image = Image.xmarkCircle
    var trailingAction: (() -> Void)? = nil //Optional because dont need to excecute everytime this view is called.

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
                
                ButtonNavigation(image: trailingImage, tintColor: textColor) {
                    if let trailingAction = trailingAction {
                        trailingAction()
                    } else {
                        dismiss() // Default value for trailing action: Close the Sheet or Go Back.
                    }
                }
                .modifier(Show(isVisible: showTrailingAction))
                .padding(.trailing)
            }
        }
    }
    
    private var titleAndSubtitle: some View {
        VStack {
            TextPlain(title,
                      color: textColor,
                      family: titleWeight,
                      size: titleSize,
                      aligment: .center,
                      lineLimit: ConstantViews.singleTextMaxLines,
                      truncateMode: .tail)
            
            TextPlain(subTitle,
                      color: textColor,
                      family: subTitleWeight,
                      size: subTitleSize,
                      aligment: .center,
                      lineLimit: ConstantViews.singleTextMaxLines,
                      truncateMode: .tail)
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
