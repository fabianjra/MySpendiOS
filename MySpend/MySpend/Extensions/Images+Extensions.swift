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
    static let dollar = Image(systemName: "dollarsign") // $
    static let colon = Image(systemName: "coloncurrencysign") // ₡
    
    // MARK: VIEW
    static let checkmarkCircleFill = Image(systemName: "checkmark.circle.fill") // Validate Account logo.
    static let checkmarkCircle = Image(systemName: "checkmark.circle")
    
    static let circleFill = Image(systemName: "circle.fill")
    static let circle = Image(systemName: "circle")

    // MARK: BUTTON
    static let plus = Image(systemName: "plus")
    static let stack = Image(systemName: "mail.stack") // History
    static let stackFill = Image(systemName: "mail.stack.fill")
    
    // MARK: TEXFIELD
    static let envelopeFill = Image(systemName: "envelope.fill") // Email
    static let lockFill = Image(systemName: "lock.fill") // Password
    static let personFill = Image(systemName: "person.fill") // Name
    static let calendar = Image(systemName: "calendar") // Date
    static let checkmark = Image(systemName: "checkmark") // Password confirmation
    
    
    // MARK: TABVIEW
    static let tabResume = Image(systemName: "list.bullet.rectangle") // Resume
    static let tabResumeFill = Image(systemName: "list.bullet.rectangle.fill")
    static let tabSettings = Image(systemName: "gearshape") // Settings
    static let tabSettingsFill = Image(systemName: "gearshape.fill")
    
    // MARK: LIST
    static let listBulletClipboard = Image(systemName: "list.bullet.clipboard") // Categories
    static let listBulletClipboardFill = Image(systemName: "list.bullet.clipboard.fill")
    
    // MARK: ARROWS
    static let arrowUp = Image(systemName: "arrow.up") //
    static let arrowRight = Image(systemName: "arrow.right") // ->
    static let arrowBackward = Image(systemName: "arrow.backward") // <-
    
    // MARK: CHEVRON
    static let chevronLeft = Image(systemName: "chevron.left") // <
    static let chevronRight = Image(systemName: "chevron.right") // <
    static let chevronUp = Image(systemName: "chevron.up")
    static let chevronDown = Image(systemName: "chevron.down")
    
    // MARK: XMARK
    static let xmarkCircle = Image(systemName: "xmark.circle")
    static let xmarkCircleFIll = Image(systemName: "xmark.circle.fill")
    
    // MARK: GENERAL
    static let arrowTurnUpLeft = Image(systemName: "arrowshape.turn.up.left")
    static let arrowTurnUpRight = Image(systemName: "arrowshape.turn.up.right")
    static let arrowTurnUpLeftFill = Image(systemName: "arrowshape.turn.up.left.fill")
    
    static let warningFill = Image(systemName: "exclamationmark.triangle.fill")
    static let xmark = Image(systemName: "xmark")

    // MARK: FUNCTIONS
    static func imageSelected(_ condition: Bool, imageSelected: Image, imageDeselected: Image) -> Image {
        if condition {
            return imageSelected.resizable()
        } else {
            return imageDeselected.resizable()
        }
    }
}
