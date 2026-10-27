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
 
 Agrupa las configuraciones de inicio de la aplicación.

 Se utiliza un enum sin casos como espacio de nombres para organizar
 propiedades estáticas e impedir la creación de instancias innecesarias.
 
 Eso da una clara intención de que no se quieren crear instancias de este tipo.

 Su elección responde a la claridad y organización del código,
 no a una ventaja de rendimiento frente a un struct.
 */
enum AppLaunchConfiguration {

    #if DEBUG
    static let showOnboarding = ProcessInfo.processInfo.arguments.contains("-showOnboarding")
    #else
    static let showOnboarding = false
    #endif
}
