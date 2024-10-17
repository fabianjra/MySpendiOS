//
//  UserModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/11/23.
//

import Foundation

struct UserModel: Identifiable, Codable {
    var id: String
    let fullname: String
    let email: String
    
    /// Take the full name and separate the first name letters.
    /// Example: Fabian Rodriugez --> FR
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            
            return formatter.string(from: components)
        }
        
        return ""
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullname
        case email
    }
}
