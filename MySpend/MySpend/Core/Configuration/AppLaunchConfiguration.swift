//
//  AppLaunchConfiguration.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/10/26.
//

import Foundation

/**
 Onboarding pendiente    Argumento -showOnboarding    Pantalla inicial
      Sí                                          No                                           Onboarding
      No                                        No                                        TransactionView
      Sí                                          Sí                                             Onboarding
      No                                        Sí                                             Onboarding
 */
enum AppLaunchConfiguration {

    #if DEBUG
    static let showOnboarding = ProcessInfo.processInfo.arguments.contains("-showOnboarding")
    #else
    static let showOnboarding = false
    #endif
}
