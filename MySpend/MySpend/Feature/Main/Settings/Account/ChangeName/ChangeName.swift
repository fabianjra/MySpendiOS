//
//  ChangeName.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import Foundation

struct ChangeName {
    var userName: String = ""
    var newUserName: String = ""
    
    enum Field: Hashable, CaseIterable {
        case newUserName
    }
}
