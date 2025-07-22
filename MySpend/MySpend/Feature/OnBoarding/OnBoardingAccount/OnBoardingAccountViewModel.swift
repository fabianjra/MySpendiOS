//
//  OnBoardingAccountViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/25.
//

import Foundation

class OnBoardingAccountViewModel: BaseViewModel {
    
    @Published var name = ""
    
    func finishOnBoarding(withName: Bool) async {
        
        if withName {
            if name.isEmptyOrWhitespace {
                errorMessage = Errors.emptySpace.localizedDescription
                return
            }
        } else {
            name = CDConstants.mainAccountName
        }
        
        let account = AccountModel(icon: ConstantSystemImage.bankDollarFill, name: name, type: .general)
        
        do {
            try await AccountManager(viewContext: viewContext).create(account)
        } catch {
            Logger.exception(error, type: .CoreData)
        }
        
        UserDefaultsManager.defaultAccountID = account.id.uuidString
        UserDefaultsManager.isOnBoarding = false
        
        Router.shared.path.append(Router.Destination.mainView)
    }
    
    enum Field: Hashable, CaseIterable {
        case name
    }
}
