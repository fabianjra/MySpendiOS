//
//  Images+Extensions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/6/23.
//

import Foundation
import SwiftUI

extension Image {
    
    //MARK: BUTTON
    static let plus = Image(systemName: "plus")
    
    //MARK: TEXFIELD
    static let envelopeFill = Image(systemName: "envelope.fill")
    static let lockFill = Image(systemName: "lock.fill")
    static let personFill = Image(systemName: "person.fill")
    static let checkmark = Image(systemName: "checkmark")
    
    //MARK: TABVIEW
    static let dolarSquare = Image(systemName: "dollarsign.square")
    static let dolarSquareFill = Image(systemName: "dollarsign.square.fill")
    static let stack = Image(systemName: "rectangle.stack")
    static let stackFill = Image(systemName: "rectangle.stack.fill")
    static let listBulletClipboard = Image(systemName: "list.bullet.clipboard")
    static let listBulletClipboardFill = Image(systemName: "list.bullet.clipboard.fill")
    static let sliderHorizontal = Image(systemName: "slider.horizontal.3")
    
    //MARK: NAVIGATION
    static let arrowBackward = Image(systemName: "arrow.backward")
    static let chevronLeft = Image(systemName: "chevron.left")
    
    //MARK: FUNCTIONS
    static func imageSelected(_ condition: Bool, imageSelected: Image, imageDeselected: Image) -> Image {
        if condition {
            return imageSelected.resizable()
        } else {
            return imageDeselected.resizable()
        }
    }
}
