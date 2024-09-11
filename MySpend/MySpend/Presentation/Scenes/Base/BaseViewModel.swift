//
//  BaseViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import SwiftUI
import Firebase

@MainActor
public class BaseViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var errorMessage = ""
    @Published var disabled: Bool = false
    
    public func validateCurrentUser() {
        if AuthFB().currentUser == nil {
            disabled = true
            errorMessage = ConstantMessages.userNotLoggedIn.localizedDescription
        }
    }
    
    public func performWithCurrentUser(_ work: @escaping (_ currentUser: User) -> Void) {
        errorMessage = ""
        
        guard let currentUser = AuthFB().currentUser else {
            disabled = true
            errorMessage = ConstantMessages.userNotLoggedIn.localizedDescription
            return
        }
        
        work(currentUser)
    }
    
    public func performWithLoader(_ work: @escaping () async -> Void) async {
        errorMessage = ""
        
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
    
    public func performWithLoader(_ work: @escaping (_ currentUser: User) async -> Void) async {
        errorMessage = ""
        
        guard let currentUser = AuthFB().currentUser else {
            errorMessage = ConstantMessages.userNotLoggedIn.localizedDescription
            return
        }
        
        withAnimation {
            isLoading = true
        }
        
        defer {
            withAnimation {
                isLoading = false
            }
        }
        
        await work(currentUser)
    }
}
