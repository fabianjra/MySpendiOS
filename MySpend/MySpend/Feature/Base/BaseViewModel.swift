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
    private var contextObserver: AnyCancellable?
    
    convenience init() {
        self.init(viewContext: CoreDataUtilities.getViewContext())
    }
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }

    /**
     Comienza a escuchar los cambios del `viewContext`.
     
     - Parameters:
        - onChange: Se ejecuta en MainActor cada vez que Core Data emite una notificación.
     */
    public func startObservingContextChanges(onChange: @escaping () -> Void) {
        guard contextObserver == nil else { return } // Evita suscribirse dos veces
        
        contextObserver = NotificationCenter.default
            .publisher(for: .NSManagedObjectContextObjectsDidChange,
                       object: viewContext)
            .debounce(for: .milliseconds(50), scheduler: RunLoop.main) // opcional, para evitar multiples llamados
            .sink { [weak self] _ in
                guard self != nil else { return }
                onChange()
            }
    }
    
    /// Detiene la observación (por ejemplo, en `onDisappear`).
    public func stopObservingContextChanges() {
        contextObserver?.cancel()
        contextObserver = nil
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
