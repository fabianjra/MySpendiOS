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
        
        guard let suite = UserDefaults(suiteName: MockUDConstants.suiteNamePreview) else {
            return UserDefaults() // Fallback: volatile in-memory store (doesn't touch real defaults)
        }
        
        suite.removePersistentDomain(forName: MockUDConstants.suiteNamePreview)
        
        return suite
    }()
}

private struct MockUDConstants {
    static let suiteNamePreview: String = "preview.myspend.app"
}
