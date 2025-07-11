//
//  Router.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import SwiftUI

class Router: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()

    static let shared: Router = Router()
    
    enum Destination {
        case mainView
        case onBoardingName
        case onBoardinAccount
    }
}
