//
//  OnBoardingAccountViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/25.
//

import Foundation

class OnBoardingAccountViewModel: BaseViewModel {
    
    @Published var accountName = ""
    
    func finishOnBoarding(withAccountName: Bool) async {
        
        var mutatedName = accountName
        
        if withAccountName {
            if accountName.isEmptyOrWhitespace {
                errorMessage = Errors.emptySpace.localizedDescription
                return
            }
        } else {
            mutatedName = CDConstants.mainAccountName
        }
        
        let account = AccountModel(icon: ConstantSystemImage.bankDollarFill, name: mutatedName, type: .general)
        
        do {
            try await AccountManager(viewContext).create(account)
            
            FilterCenter.shared.selectedAccountsFilter.insert(account.id)
            
            UserDefaultsManager.defaultAccountID = account.id.uuidString
            UserDefaultsManager.isOnBoarding = false

            Router.shared.reset()
        } catch {
            Logger.exception(error, type: .CoreData)
            errorMessage = error.localizedDescription
        }
    }
    
    enum Field: Hashable, CaseIterable {
        case accountName
    }
}
