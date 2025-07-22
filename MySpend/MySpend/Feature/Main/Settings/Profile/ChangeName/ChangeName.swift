//
//  ChangeName.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import Foundation

struct ChangeName {
    var username: String = ""
    var newUsername: String = ""
    
    enum Field: Hashable, CaseIterable {
        case newUsername
    }
}
