//
//  UserModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/11/23.
//

import Foundation

struct UserModel: Identifiable, Codable {
    let id: String
    
    let fullname: String
    let email: String
    let phoneNumber: String?
    let profilePicture: URL?
    
    let accounts: [AccountModel]
    let categories: [CategoryModel]
    
    
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
        case phoneNumber
        case profilePicture
        
        case accounts
        case categories
    }
}
