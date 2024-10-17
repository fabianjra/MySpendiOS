//
//  MainViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 16/10/24.
//

import Foundation

class MainViewModel: BaseViewModel {
    @Published var showNewTransactionModal = false
    @Published var selectedTab: TabViewIcons = .resume
    @Published var navigateToHistory: Bool = false
}
