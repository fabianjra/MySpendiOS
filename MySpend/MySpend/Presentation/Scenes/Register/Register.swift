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
            guard let currentIndex = Register.Field.allCases.firstIndex(of: self) else {
                return nil
            }
            
            // Verifica si hay un siguiente campo.
            let nextIndex = Register.Field.allCases.index(after: currentIndex)
            return nextIndex < Register.Field.allCases.endIndex ? Register.Field.allCases[nextIndex] : nil
        }
        
        func previous() -> Register.Field? {
            guard let currentIndex = Register.Field.allCases.firstIndex(of: self) else {
                return nil
            }
            
            // Verifica si hay un campo anterior.
            let previousIndex = Register.Field.allCases.index(before: currentIndex)
            return currentIndex > .zero ? Register.Field.allCases[previousIndex] : nil
        }
        
    }
}
