//
//  OnBoardingAccountViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/25.
//

import Foundation

class OnBoardingAccountViewModel: BaseViewModel {
    
    @Published var accountName = ""
    
    func finishOnBoarding(withAccountName: Bool, accountManager: AccountManager) async {
        
        var mutatedName = accountName
        
        if withAccountName {
            if accountName.isEmptyOrWhitespace {
                errorMessage = Errors.emptySpace.localizedDescription
                return
            }
        } else {
            mutatedName = CDConstants.mainAccountName
        }
        
        let account = AccountModel(icon: ConstantSystemImage.bankDollarFill, name: mutatedName)
        
        do {
            try await AccountCoreDataManager(viewContext).create(account)
            
            accountManager.filteredAccountIDs.insert(account.id)
            
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
