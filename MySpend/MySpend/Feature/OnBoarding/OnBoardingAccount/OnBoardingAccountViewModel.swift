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
    
    func finishOnBoarding(withAccountName: Bool, accountManager: AccountManager) async -> ToastResponse? {
        
        if withAccountName && accountName.isEmptyOrWhiteSpace {
            return ToastResponse(.responseErrorTextFieldEmptySpace, .error)
        }
        
        let name = withAccountName ? accountName : String(localized: .accountCreateDefaultName)
        let account = AccountModel(icon: ConstantSystemImage.bankDollarFill, name: name)
        
        return await accountManager.create(account, isDefault: true)
    }
}
