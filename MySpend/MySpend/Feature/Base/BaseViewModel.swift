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
