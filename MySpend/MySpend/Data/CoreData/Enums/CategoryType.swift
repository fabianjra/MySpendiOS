//
//  CategoryType.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 16/10/24.
//

enum CategoryType: String, CaseIterable, Identifiable, Codable, Hashable, LocalizableProtocol {
    public var id: Self { self }
    
    case expense
    case income
    
    var table: String { LocalizableTable.enums }
}
