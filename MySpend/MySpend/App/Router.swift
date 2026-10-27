//
//  Router.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import SwiftUI

@Observable
final class Router {
    static let shared: Router = Router()
    
    var path = NavigationPath()
    var onboardingPath = NavigationPath()
    
    private init() {}
    
    func navigate(to destination: Destination) {
        switch destination {
            
        case .onBoardinAccount:
            onboardingPath.append(destination)
            
        case .settings:
            path.append(destination)
        }
    }
    
    func reset() {
        path = NavigationPath()
    }
    
    func resetOnboarding() {
        onboardingPath = NavigationPath()
    }
    
    enum Destination {
        case onBoardinAccount
        case settings
    }
}
