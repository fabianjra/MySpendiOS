//
//  Register.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

struct Register {
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var passwordConfirm: String = ""
    
    enum Field: Hashable, CaseIterable {
        case name
        case email
        case password
        case passwordConfirm
        
        func next() -> Register.Field? {
            switch self {
            case .name:
                return .email
            case .email:
                return .password
            case .password:
                return .passwordConfirm
            default:
                return nil
            }
        }

        func previous() -> Register.Field? {
            switch self {
            case .email:
                return .name
            case .password:
                return .email
            case .passwordConfirm:
                return .password
            default:
                return nil
            }
        }
    }
}
