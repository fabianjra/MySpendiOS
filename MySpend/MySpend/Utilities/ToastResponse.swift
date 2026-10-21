//
//  ToastResponse.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 30/8/26.
//

import Foundation

struct ToastResponse: Identifiable {
    let id = UUID()
    
    let message: LocalizedStringResource
    let type: ResponseType?
    
    init(_ message: LocalizedStringResource = .responseSuccesful,
         _ type: ResponseType? = nil) {
        self.message = message
        self.type = type
    }
}

enum ResponseType: String {
    case ok = "✅"
    case error = "❌"
}
