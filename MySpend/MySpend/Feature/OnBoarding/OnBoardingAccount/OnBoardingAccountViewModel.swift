//
//  OnBoardingAccountViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/25.
//

import Observation

@Observable
final class OnBoardingAccountViewModel {
    
    var accountName = ""
    var toastResponse: ToastResponse?
    
    func finishOnBoarding(withAccountName: Bool, accountManager: AccountManager) async {
        
        if withAccountName && accountName.isEmptyOrWhitespace {
            toastResponse = ToastResponse(.responseErrorTextFieldEmptySpace, .error)
            return
        }
        
        let name = withAccountName ? accountName : String(localized: .accountCreateDefaultName)
        let account = AccountModel(icon: ConstantSystemImage.bankDollarFill, name: name)
        
        toastResponse = await accountManager.create(account, isDefault: true)
        
        if toastResponse?.type == .ok {
            UserDefaultsManager.isOnBoarding = false
        }
    }
}
