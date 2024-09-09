//
//  Images+Extensions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/6/23.
//

import Foundation
import SwiftUI

extension Image {
    
    // MARK: CURRENCY
    static let dolarSquare = Image(systemName: "dollarsign.circle") // $
    static let dolarSquareFill = Image(systemName: "dollarsign.circle.fill")
    
    // MARK: BUTTON
    static let plus = Image(systemName: "plus")
    static let stack = Image(systemName: "mail.stack") // History
    static let stackFill = Image(systemName: "mail.stack.fill")
    
    // MARK: TEXFIELD
    static let envelopeFill = Image(systemName: "envelope.fill") // Email
    static let lockFill = Image(systemName: "lock.fill") // Password
    static let personFill = Image(systemName: "person.fill") // Name
    static let checkmark = Image(systemName: "checkmark") // Password confirmation
    static let calendar = Image(systemName: "calendar") // Date
    
    // MARK: TABVIEW
    static let tabResume = Image(systemName: "list.bullet.rectangle") // Resume
    static let tabResumeFill = Image(systemName: "list.bullet.rectangle.fill")
    static let tabSettings = Image(systemName: "gear.circle") // Settings
    static let tabSettingsFill = Image(systemName: "gear.circle.fill")
    
    // MARK: LIST
    static let listBulletClipboard = Image(systemName: "list.bullet.clipboard") // Categories
    static let listBulletClipboardFill = Image(systemName: "list.bullet.clipboard.fill")
    
    // MARK: NAVIGATION
    static let arrowRight = Image(systemName: "arrow.right") // ->
    static let arrowBackward = Image(systemName: "arrow.backward") // <-
    static let chevronLeft = Image(systemName: "chevron.left") // <
    static let chevronRight = Image(systemName: "chevron.right") // <
    static let chevronUp = Image(systemName: "chevron.up")
    static let chevronDown = Image(systemName: "chevron.down")
    
    // MARK: GENERAL
    static let warningFill = Image(systemName: "exclamationmark.triangle.fill")
    static let arrowTurnUpLeft = Image(systemName: "arrowshape.turn.up.left")
    static let arrowTurnUpLeftFill = Image(systemName: "arrowshape.turn.up.left.fill")

    // MARK: FUNCTIONS
    static func imageSelected(_ condition: Bool, imageSelected: Image, imageDeselected: Image) -> Image {
        if condition {
            return imageSelected.resizable()
        } else {
            return imageDeselected.resizable()
        }
    }
}
