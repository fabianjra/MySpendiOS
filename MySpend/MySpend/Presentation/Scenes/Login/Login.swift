//
//  LoginModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

struct Login {
    var email: String = ""
    var password: String = ""
    
    /// Used for @FocusState in the Login View.
    enum Field: Hashable, CaseIterable {
        case email
        case password
        
        func next() -> Login.Field? {
            guard let currentIndex = Login.Field.allCases.firstIndex(of: self) else {
                return nil
            }
            
            // Verifica si hay un siguiente campo.
            let nextIndex = Login.Field.allCases.index(after: currentIndex)
            return nextIndex < Login.Field.allCases.endIndex ? Login.Field.allCases[nextIndex] : nil
        }
        
        func previous() -> Login.Field? {
            guard let currentIndex = Login.Field.allCases.firstIndex(of: self) else {
                return nil
            }
            
            // Verifica si hay un campo anterior.
            let previousIndex = Login.Field.allCases.index(before: currentIndex)
            return currentIndex > .zero ? Login.Field.allCases[previousIndex] : nil
        }
    }
}
