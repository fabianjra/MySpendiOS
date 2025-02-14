//
//  UserModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/11/23.
//

import Foundation
import SwiftData

@Model
class UserModel: Identifiable {
    
    var id: String
    
    var fullname: String
    var email: String
    var phoneNumber: String?
    var profilePicture: URL?
    
    // If the user is deleted, avery account related to it also will be deleted.
    @Relationship(deleteRule: .cascade, inverse: \AccountModel.user)
    var accounts: [AccountModel]
    
    init(id: String,
         fullname: String,
         email: String,
         phoneNumber: String? = nil,
         profilePicture: URL? = nil,
         accounts: [AccountModel]) {
        
        self.id = id
        self.fullname = fullname
        self.email = email
        self.phoneNumber = phoneNumber
        self.profilePicture = profilePicture
        self.accounts = accounts
    }
    
    
    /// Take the full name and separate the first name letters.
    /// Example: Fabian Rodriguez --> FR
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            
            return formatter.string(from: components)
        }
        
        return ""
    }
}
