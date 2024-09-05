//
//  BaseViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import SwiftUI

@MainActor
class BaseViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    
    func performWithLoader(_ work: @escaping () async -> Void) async {
        withAnimation {
            isLoading = true
        }
        
        defer {
            withAnimation {
                isLoading = false
            }
        }
        
        await work()
    }
}
