//
//  BaseViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import SwiftUI
import FirebaseAuth

@MainActor
public class BaseViewModelFB: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var isLoadingSecondary: Bool = false
    @Published var errorMessage = ""
    @Published var disabled: Bool = false
    
    public func validateCurrentUser() {
        if AuthFB().currentUser == nil {
            disabled = true
            errorMessage = Errors.userNotLoggedIn.localizedDescription
        }
    }
    
    public func performWithCurrentUser(_ action: @escaping (_ currentUser: User) -> Void) {
        errorMessage = ""
        
        guard let currentUser = AuthFB().currentUser else {
            disabled = true
            errorMessage = Errors.userNotLoggedIn.localizedDescription
            return
        }
        
        action(currentUser)
    }
    
    public func performWithLoader(_ action: @escaping () async -> Void) async {
        errorMessage = ""
        
        withAnimation {
            isLoading = true
        }
        
        defer {
            withAnimation {
                isLoading = false
            }
        }
        
        await action()
    }
    
    public func performWithLoaderSecondary(_ action: @escaping () async -> Void) async {
        errorMessage = ""
        
        withAnimation {
            isLoadingSecondary = true
        }
        
        defer {
            withAnimation {
                isLoadingSecondary = false
            }
        }
        
        await action()
    }
    
    public func performWithLoader(_ action: @escaping (_ currentUser: User) async -> Void) async {
        errorMessage = ""
        
        guard let currentUser = AuthFB().currentUser else {
            errorMessage = Errors.userNotLoggedIn.localizedDescription
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
        
        await action(currentUser)
    }
}
