//
//  ChangeNameViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import Foundation

class ChangeNameViewModel: BaseViewModel {

    @Published var changeName = ChangeName()
    
    func changeUserName() async {
        await performWithLoading {
            
            if self.changeName.newUserName.isEmptyOrWhitespace() {
                self.changeName.errorMessage = ConstantMessages.emptySpace.localizedDescription
                return
            }
            
            do {
                try await SessionStore.updateUser(newUserName: self.changeName.newUserName)
                
                self.changeName.errorMessage = "NAME CHANGED TO: \(UtilsStore.getCurrentUser()?.displayName ?? "")"
            } catch {
                self.changeName.errorMessage = error.localizedDescription
            }
        }
    }
    
    func onAppear() {
        do {
            changeName.userName = try SessionStore.getUserName()
        } catch {
            changeName.buttonDisabled = true
            changeName.errorMessage = error.localizedDescription
        }
    }
}
