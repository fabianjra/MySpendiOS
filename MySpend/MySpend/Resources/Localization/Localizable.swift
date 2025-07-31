//
//  LocalizationKey.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 27/7/25.
//

import SwiftUICore

struct LocalizableTable {
    
    static let main = "Localizable"
    
    
    // MARK: - Features
    
    static let onboarding = "Onboarding"
    static let transaction = "Transaction"
    
    
    // MARK: - Generic
    
    static let view = "View"
    static let button = "Button"
    static let enums = "Enums"
}

/// Todo enum que herede de este protocolo debe conformar a table: Para saber en que catalogo ir a buscar su Localizeble y rawValue para que sea un string a utulizar como key y buscar su valor en el catalogo correcto.
protocol LocalizableProtocol {
    var rawValue: String { get }
    var table: String { get }
}

extension LocalizableProtocol {
    var key: LocalizedStringKey {
        LocalizedStringKey(self.rawValue)
    }
    
    /// Para los enumerables que van en el PickerView: Deben conformarlo para localizar sus textos y deben ir en el catalogo de Enums
    var localized: String {
        String(localized: String.LocalizationValue(self.rawValue), table: self.table)
    }
}

struct Localizable {
    
    // MARK: - Features
    
    enum Onboarding: String, LocalizableProtocol {
        case title
        case enter_name
        case enter_account_name
        
        var table: String { LocalizableTable.onboarding }
    }
    
    enum Transaction: String, LocalizableProtocol {
        case welcome
        
        var table: String { LocalizableTable.transaction }
    }
    
    // MARK: - Generic
    
    enum View: String, LocalizableProtocol {
        case empty
        case empty_add_item
        
        var table: String { LocalizableTable.view }
    }
    
    enum Button: String, LocalizableProtocol {
        case continu = "continue"
        case skip
        case history
        case history_subtitle
        
        var table: String { LocalizableTable.button }
    }
}
