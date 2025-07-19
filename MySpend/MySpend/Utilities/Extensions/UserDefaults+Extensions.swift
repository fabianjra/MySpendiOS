//
//  UserDefaults+Extensions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 19/7/25.
//

import Foundation

extension UserDefaults {
    
    /**
     Suite exclusiva para previews.
     Se borra cada vez.
     */
    static var preview: UserDefaults = {
        if let suite = UserDefaults(suiteName: MockUDConstants.suiteNamePreview) {
            suite.removePersistentDomain(forName: MockUDConstants.suiteNamePreview)
            return suite
        }
        
        // Fallback: volatile in-memory store (doesn't touch real defaults)
        return UserDefaults()
    }()
}

private struct MockUDConstants {
    static let suiteNamePreview: String = "MySpend.Preview"
}
