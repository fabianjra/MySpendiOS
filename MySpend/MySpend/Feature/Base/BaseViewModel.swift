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
    @Published var isLoading: Bool = false
    @Published var isLoadingSecondary: Bool = false
    @Published var errorMessage = ""
    @Published var disabled: Bool = false
    
    // MARK: - Core Data
    let viewContext: NSManagedObjectContext
    
    // MARK: - Suscripción
    private var viewContextObserver: AnyCancellable?
    private var userDefaultsObserver: AnyCancellable?
    
    // MARK: - Inits
    convenience init() {
        self.init(viewContext: CoreDataUtilities.getViewContext())
    }
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }

    // MARK: - Funciones
    /**
     Comienza a escuchar los cambios del `viewContext`.
     
     - Parameters:
        - onChange: Se ejecuta en MainActor cada vez que Core Data emite una notificación.
     */
    func startObserveViewContextChanges(onChange: @escaping () -> Void) {
        guard viewContextObserver == nil else { return } // Evita suscribirse dos veces
        
        viewContextObserver = NotificationCenter.default
            .publisher(for: .NSManagedObjectContextObjectsDidChange,
                       object: viewContext)
            .debounce(for: .milliseconds(50), scheduler: RunLoop.main) // opcional, para evitar multiples llamados
            .sink { [weak self] _ in
                guard self != nil else { return }
                onChange()
            }
    }
    
    func startObserveUserDefaultsChanges(object: UserDefaults = UserDefaultsManager.userDefaults, onChange: @escaping () -> Void) {
        guard userDefaultsObserver == nil else { return } // Evita suscribirse dos veces
        
        userDefaultsObserver = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification, object: object)
            .receive(on: RunLoop.main)
        
        /**
         ¿Por qué no hay ciclo en la versión simple?
         1- BaseViewModel guarda un AnyCancellable (referencia fuerte al cierre).
         2- El cierre no captura self, así que no hay closure → self.
         3- Resultado: self → cancellable → closure queda en una sola dirección; se rompe al llamar a stopObservingUserDefaultsChanges().
         
         Si en el futuro quisieras acceder a propiedades o métodos de la instancia dentro del sink, entonces sí agrega [weak self] para evitar ciclos:
         */
            .sink { _ in onChange() }
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

    public func performWithLoader(_ action: @escaping () async -> Void) async {
        errorMessage = ""
        
        withAnimation {
            isLoading = true
        }
        
        defer {
            withAnimation {
                isLoading = false
            }
        }
        
        await action()
    }
    
    public func performWithLoaderSecondary(_ action: @escaping () async -> Void) async {
        errorMessage = ""
        
        withAnimation {
            isLoadingSecondary = true
        }
        
        defer {
            withAnimation {
                isLoadingSecondary = false
            }
        }
        
        await action()
    }
}
