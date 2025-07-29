//
//  LocalizationKey.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 27/7/25.
//

import SwiftUICore

struct Tables {
    
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
protocol Localizable {
    var rawValue: String { get }
    var table: String { get }
}

extension Localizable {
    var key: LocalizedStringKey {
        LocalizedStringKey(self.rawValue)
    }
    
    /// Para los enumerables que van en el PickerView: Deben conformarlo para localizar sus textos y deben ir en el catalogo de Enums
    var localized: String {
        String(localized: String.LocalizationValue(self.rawValue), table: self.table)
    }
}

struct Localizations {
    
    // MARK: - Features
    
    enum onboarding: String, Localizable {
        case title
        case enter_name
        case enter_account_name
        
        var table: String { Tables.onboarding }
    }
    
    enum transaction: String, Localizable {
        case welcome
        
        var table: String { Tables.transaction }
    }
    
    // MARK: - Generic
    
    enum view: String, Localizable {
        case empty
        case empty_add_item
        
        var table: String { Tables.view }
    }
    
    enum button: String, Localizable {
        case continu = "continue"
        case skip
        case history
        case history_subtitle
        
        var table: String { Tables.button }
    }
}
