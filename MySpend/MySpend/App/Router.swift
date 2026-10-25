//
//  Router.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import SwiftUI

@Observable
class Router {
    var path = NavigationPath()

    static let shared: Router = Router()
    
    private init() {}
    
    func reset() {
        path = NavigationPath()
    }
    
    func navigate(to destination: Destination) {
        path.append(destination)
    }
    
    enum Destination {
        case mainView
        case onBoardingName
        case onBoardinAccount
        case settings
    }
}
