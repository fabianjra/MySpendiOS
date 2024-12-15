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
    
    // MARK: MENU SORT TRANSACTIONS
    
    static let dateNewestFirst = Label("Date (Newest first)", systemImage: ConstantSystemImage.arrowDown)
    static let dateOldestFirst = Label("Date (Oldest first)", systemImage: ConstantSystemImage.arrowUp)
    
    static let amountHighesttFirst = Label("Amount (Highest first)", systemImage: ConstantSystemImage.arrowDown)
    static let amountLowestFirst = Label("Amount (Lowest first)", systemImage: ConstantSystemImage.arrowUp)
    
    static let categoryNameAz = Label("Category name (A-Z)", systemImage: ConstantSystemImage.arrowDown)
    static let categoryNameZa = Label("Category name (Z-A)", systemImage: ConstantSystemImage.arrowUp)
}
