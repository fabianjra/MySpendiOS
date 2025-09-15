//
//  LocalizationKey.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 27/7/25.
//

import SwiftUI

struct LocalizableTable {
    
    static let main = "Localizable"
    
    
    // MARK: - Features
    
    static let onboarding = "Onboarding"

    
    // MARK: - Generic
    
    static let user = "User"
    static let data = "Data"
    static let button = "Button"
    static let currency = "Currency"
    
    // MARK: - Shared
    
    static let enums = "Enums"
}

/// Todo enum que herede de este protocolo debe conformar a table: Para saber en que catalogo ir a buscar su Localizeble y rawValue para que sea un string a utulizar como key y buscar su valor en el catalogo correcto.
protocol LocalizableProtocol {
    var rawValue: String { get }
    var table: String { get }
}

extension LocalizableProtocol {
    
    /// Key es un valor en el que para todos se aplica de la misma forma, por lo que se deja en extension para que la implementacion dentro del ENUM sea opcional si se quiere realizar de diferente forma.
    /// A diferencia de table, en donde cada enum tiene su propio valor por Catalogo, key es un valor por igual para cada enum ya que se basa en sus propios case internos.
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
    
    // MARK: - Generic
    
    enum User: String, LocalizableProtocol {
        case welcome
        
        var table: String { LocalizableTable.user }
    }
    
    enum Data: String, LocalizableProtocol {
        case empty
        case empty_add_item
        
        var table: String { LocalizableTable.data }
    }
    
    enum Button: String, LocalizableProtocol {
        case continu = "continue"
        case skip
        case history
        case history_subtitle
        
        var table: String { LocalizableTable.button }
    }
    
    enum Currency: String, LocalizableProtocol {
        case incomes
        case expenses
        case total_balance
        
        var table: String { LocalizableTable.currency }
    }
}
