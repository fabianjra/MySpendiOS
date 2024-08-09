//
//  ChangeNameViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import Foundation

class ChangeNameViewModel: BaseViewModel {

    @Published var model = ChangeName()
    
    func changeUserName() async {
        
        if model.newUserName.isEmptyOrWhitespace() {
            model.errorMessage = ConstantMessages.emptySpace.localizedDescription
            return
        }
        
        await performWithLoader {
            do {
                try await SessionStore.updateUser(newUserName: self.model.newUserName)
                
                self.model.errorMessage = "NAME CHANGED TO: \(UtilsStore.getCurrentUser()?.displayName ?? "")"
            } catch {
                self.model.errorMessage = error.localizedDescription
            }
        }
    }
    
    func onAppear() {
        do {
            model.userName = try SessionStore.getUserName()
        } catch {
            model.disabled = true
            model.errorMessage = error.localizedDescription
        }
    }
}
