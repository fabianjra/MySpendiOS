//
//  BaseViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 6/7/25.
//

import Combine
import CoreData
import SwiftUI

@MainActor
public class BaseViewModel: ObservableObject {
    
    // MARK: - Estado común
    @Published var errorMessage = ""
    @Published var disabled: Bool = false
    
    // MARK: - Core Data
    let viewContext: NSManagedObjectContext
    
    // MARK: - Suscripción
    private var viewContextObserver: AnyCancellable?
    private var userDefaultsObserver: AnyCancellable?
    
    // MARK: - Inits
    init() {
        self.viewContext = CoreDataUtilities.getViewContext
    }
    
    // MARK: - Funciones
    /**
     Comienza a escuchar los cambios del `viewContext`.
     
     - Parameters:
     - onChange: Se ejecuta en MainActor cada vez que Core Data emite una notificación.
     */
    func startObserveViewContextChanges(onChange: @escaping @Sendable () async -> Void) {
        guard viewContextObserver == nil else { return } // Evita suscribirse dos veces
        
        viewContextObserver = NotificationCenter.default
            .publisher(for: .NSManagedObjectContextObjectsDidChange,
                       object: viewContext)
            .debounce(for: .milliseconds(50), scheduler: RunLoop.main) // opcional, para evitar multiples llamados
            //.receive(on: DispatchQueue.main) // Redundante: Puedes omitir .receive(on: DispatchQueue.main); con el debounce sobre RunLoop.main ya garantizas que el sink se ejecute en el hilo principal.
            .sink { [weak self] _ in
                guard self != nil else { return }
                
                // Al parecer @MainActor in... pero es redudante, ya la clase usa MainActor, pero se agrega para asegurar que el cuerpo corra sobre el hilo principal.
                // El MainActor podria anotarse despues de @escaping en el parametro, para no dejarlo dentro de Task. Es una alternativa.
                Task { @MainActor in
                    await onChange()
                }
            }
    }
    
    func startObserveUserDefaultsChanges(object: UserDefaults = UserDefaultsManager.userDefaults, onChange: @escaping () -> Void) {
        guard userDefaultsObserver == nil else { return } // Evita suscribirse dos veces
        
        userDefaultsObserver = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification, object: object)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard self != nil else { return }
                onChange()
            }
    }
    
    /// Detiene la observación (por ejemplo, en `onDisappear`).
    public func stopObservingContextChanges() {
        viewContextObserver?.cancel()
        viewContextObserver = nil
    }
    
    public func stopObserveUserDefaultsChanges() {
        userDefaultsObserver?.cancel()
        userDefaultsObserver = nil
    }
}
