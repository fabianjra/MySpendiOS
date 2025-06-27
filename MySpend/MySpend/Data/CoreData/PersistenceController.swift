//
//  Persistence.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 3/6/25.
//

import CoreData

// Persintence:
// Este es el que enlaza el Modelo de Core Data con el codigo.
// Aqui se inicializa todo lo que tiene que ver con Core Data.
// Desde este struct Persintence, es que se accede a Core Data.

struct PersistenceController {
    
    // Solo debe existir una sola instancia del contenedor.
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<5 {
            let newItem = Category(context: viewContext)
            newItem.id = UUID()
            
            newItem.dateCreated = .now
            newItem.dateLastUsed = .now
            newItem.dateModified = .now
            newItem.icon = "star"
            newItem.isActive = true
            newItem.name = "Prueba"
            newItem.type = "expense"
            newItem.usageCount = 0
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    // Contenedor de Core Data.
    let container: NSPersistentContainer

    // inMemory: false (default): Guarda datos reales en disco (uso normal).
    // inMemory: true: Solo usa memoria temporal (ideal para tests o previews).
    init(inMemory: Bool = false) {
        
        container = NSPersistentContainer(name: CoreDataConstants.containerName)
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // Inicializa el contenedor y carga el contenido de Core Data
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unable to load persistent stores: \(error.localizedDescription). UserInfo: \(error.userInfo)")
            }
        })
        
        // Cuando se crea un Core Data Model y se crea un Persistence Container enlazado al modelo,
        // Se va a crear una propiedad llamada viewContext.
        // Este viewContext es la propiedad con la que se va a interactuar en toda la aplicacion para usar para manejar datos.
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        // NOTA:
        // automaticallyMergesChangesFromParent:
        // Cada vez que el viewContext cambia desde el "parent context", cada "Child Context" va a cambiar tambien.
        // Esto indica que no importa sobre que "context" se realicen cambios, siempre se realizaran por el merge.
    }
}
