//
//  UserModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/11/23.
//

import Foundation
import SwiftData

@Model
class UserModel: Identifiable, Codable {
    
    @Attribute(.unique) var id: String
    
    var fullname: String
    var email: String
    var phoneNumber: String?
    var profilePicture: URL?
    
    @Relationship(deleteRule: .cascade) var accounts: [AccountModel]
    
    init(id: String, fullname: String, email: String, phoneNumber: String? = nil, profilePicture: URL? = nil, accounts: [AccountModel]) {
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
    
    enum CodingKeys: String, CodingKey {
        case id
        
        case fullname
        case email
        case phoneNumber
        case profilePicture
        
        case accounts
    }
    
    // MARK: - Decodable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        fullname = try container.decode(String.self, forKey: .fullname)
        email = try container.decode(String.self, forKey: .email)
        phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        profilePicture = try container.decodeIfPresent(URL.self, forKey: .profilePicture)
        
        // Decodificación de relaciones
        accounts = try container.decodeIfPresent([AccountModel].self, forKey: .accounts) ?? []
    }
    
    // MARK: - Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(fullname, forKey: .fullname)
        try container.encode(email, forKey: .email)
        try container.encodeIfPresent(phoneNumber, forKey: .phoneNumber)
        try container.encodeIfPresent(profilePicture, forKey: .profilePicture)
        
        // Codificación de relaciones
        try container.encode(accounts, forKey: .accounts)
    }
}
