//
//  Label+Extensions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 30/10/24.
//

import SwiftUI

extension Label where Title == Text, Icon == Image {
    
    // MARK: SWIPE ACTIONS
    
    static let delete = Label("Delete", systemImage: ConstantSystemImage.trash)
    static let edit = Label("Edit", systemImage: ConstantSystemImage.squareAndPencil)
    
    // MARK: MENU SORT
    
    static let restoreSelection = Label("Reset selection", systemImage: ConstantSystemImage.arrowCounterClockwise)
    static let type = Label("Type", systemImage: ConstantSystemImage.walletPassFill)
    
    // MARK: MENU SORT TRANSACTIONS
    
    static let dateNewestFirst = Label("Date (Newest first)", systemImage: ConstantSystemImage.arrowUp)
    static let dateOldestFirst = Label("Date (Oldest first)", systemImage: ConstantSystemImage.arrowDown)
    
    static let amountHighesttFirst = Label("Amount (Highest first)", systemImage: ConstantSystemImage.arrowUp)
    static let amountLowestFirst = Label("Amount (Lowest first)", systemImage: ConstantSystemImage.arrowDown)
    
    static let categoryNameAz = Label("Category name (A-Z)", systemImage: ConstantSystemImage.arrowDown)
    static let categoryNameZa = Label("Category name (Z-A)", systemImage: ConstantSystemImage.arrowUp)
    
    // MARK: MENU SORT CATEGORIES
    
    static let creationNewestFirst = Label("Creation (Newest first)", systemImage: ConstantSystemImage.arrowUp)
    static let creationOldestFirst = Label("Creation (Oldest first)", systemImage: ConstantSystemImage.arrowDown)
    
    static let nameAz = Label("Name (A-Z)", systemImage: ConstantSystemImage.arrowDown)
    static let nameZa = Label("Name (Z-A)", systemImage: ConstantSystemImage.arrowUp)
    
    static let mostOftenUsed = Label("Most often used", systemImage: ConstantSystemImage.clockArrowCounterClockwise)
}
