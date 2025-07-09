//
//  MockAccount.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 6/7/25.
//

import Foundation
import CoreData

struct MocksEntities {
    
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Accounts:
        createAccounts(viewContext)
        
        // Categories:
        createCategories(viewContext)
        
        // Asegura que los fetch vean las inserciones:
        //viewContext.processPendingChanges()
        
        // Transactions:
        createTransactions(viewContext)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Error al cargar CoreData en MockAccount: \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    private static func createAccounts(_ context: NSManagedObjectContext) {
        let newItem = Account(context: context)
        newItem.dateCreated = Calendar.current.date(byAdding: .day, value: 1, to: .now)!
        newItem.dateModified = .now
        newItem.id = UUID()
        newItem.isActive = true
        
        newItem.icon = "person.fill"
        newItem.name = "Main account"
        newItem.notes = "No notes"
        newItem.type = AccountType.general.rawValue
        newItem.userId = "Firebase_User_UUID"
        
        let newItem2 = Account(context: context)
        newItem2.dateCreated = Calendar.current.date(byAdding: .day, value: 2, to: .now)!
        newItem2.dateModified = .now
        newItem2.id = UUID()
        newItem2.isActive = true
        
        newItem2.icon = ""
        newItem2.name = "Secondary account"
        newItem2.notes = ""
        newItem2.type = AccountType.expenses.rawValue
        newItem2.userId = ""
    }
    
    private static func createCategories(_ context: NSManagedObjectContext) {
        for item in 0..<2 {
            let newItem = Category(context: context)
            newItem.dateCreated = Calendar.current.date(byAdding: .day, value: item, to: .now)!
            newItem.dateModified = .now
            newItem.id = UUID()
            newItem.isActive = true
            
            newItem.dateLastUsed = .now
            newItem.icon = "✅"
            newItem.name = "Gasto: \(item)"
            newItem.type = CategoryType.expense.rawValue
            newItem.usageCount = 0
        }
        
        for item in 0..<3 {
            let newItem = Category(context: context)
            newItem.dateCreated = Calendar.current.date(byAdding: .day, value: item, to: .now)!
            newItem.dateModified = .now
            newItem.id = UUID()
            newItem.isActive = true
            
            newItem.dateLastUsed = Calendar.current.date(byAdding: .day, value: item + 2, to: .now)!
            newItem.icon = "✅"
            newItem.name = "Ingreso: \(item)"
            newItem.type = CategoryType.income.rawValue
            newItem.usageCount = 1
        }
    }
    
    private static func createTransactions(_ context: NSManagedObjectContext) {
        
        let newItem1 = Transaction(context: context)
        newItem1.dateCreated = Calendar.current.date(byAdding: .day, value: 3, to: .now)!
        newItem1.dateModified = .now
        newItem1.id = UUID()
        newItem1.isActive = true
        
        newItem1.amount = 500
        newItem1.dateTransaction = .now
        newItem1.notes = "No notes"
        newItem1.category =  CoreDataUtilities.createCategoryEntity(from: fetchCategory(context), viewContext: context)
        newItem1.account = CoreDataUtilities.createAccountEntity(from: fetchAccount(context), viewContext: context)
        
        let newItem2 = Transaction(context: context)
        newItem2.dateCreated = Calendar.current.date(byAdding: .day, value: 20, to: .now)!
        newItem2.dateModified = .now
        newItem2.id = UUID()
        newItem2.isActive = true
        
        newItem2.amount = 122343.15
        newItem2.dateTransaction = .now
        newItem2.notes = ""
        newItem2.category =  CoreDataUtilities.createCategoryEntity(from: fetchCategory(context, type: .income), viewContext: context)
        newItem2.account = CoreDataUtilities.createAccountEntity(from: fetchAccount(context, type: .general), viewContext: context)
        
    }
    
    private static func fetchCategory(_ context: NSManagedObjectContext, type: CategoryType = .expense) -> CategoryModel {
        do {
            let categories = try CategoryManager(viewContext: context).fetchAll()
            let expense = categories.first(where: { $0.type == type })
            return expense ?? CategoryModel()
        } catch {
            let nsError = error as NSError
            fatalError("Error al obtener la categoria \(type.rawValue) : \(nsError), \(nsError.userInfo)")
        }
    }
    
    private static func fetchAccount(_ context: NSManagedObjectContext, type: AccountType = .general) -> AccountModel {
        do {
            let accounts = try AccountManager(viewContext: context).fetchAll()
            let expense = accounts.first(where: { $0.type == type })
            return expense ?? AccountModel()
        } catch {
            let nsError = error as NSError
            fatalError("Error al obtener la cuenta \(type.rawValue) : \(nsError), \(nsError.userInfo)")
        }
    }
}
