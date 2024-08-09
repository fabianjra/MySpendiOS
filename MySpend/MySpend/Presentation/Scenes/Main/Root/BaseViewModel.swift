//
//  BaseViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import Foundation

@MainActor
class BaseViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    
    func performWithLoading(_ work: @escaping () async -> Void) async {
        isLoading = true
        defer {
            isLoading = false
        }
        
        await work()
    }
}
