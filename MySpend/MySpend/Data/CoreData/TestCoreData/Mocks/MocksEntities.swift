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
        
        // Asegura que los fetch vean las inserciones:
        //viewContext.processPendingChanges()
        
        // Accounts:
        let accountMain = MocksEntities.accountMain(viewContext)
        let accountGeneral = MocksEntities.accountGeneral(viewContext)
        
        // Categories:
        let categoryExpense = MocksEntities.categoryExpense(viewContext)
        let categoryIncome = MocksEntities.categoryIncome(viewContext)
        
        // Transactions:
        MocksEntities.transactionExpense(viewContext, category: categoryExpense, account: accountMain)
        MocksEntities.transactionExpense(viewContext, category: categoryIncome, account: accountMain)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Error al cargar CoreData en MockAccount: \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    private static func accountMain(_ context: NSManagedObjectContext) -> Account {
        let item = Account(context: context)
        item.dateCreated = Calendar.current.date(byAdding: .day, value: 1, to: .now)!
        item.dateModified = .now
        item.id = UUID()
        item.isActive = true
        
        item.icon = "person.fill"
        item.name = "Main account"
        item.notes = "No notes"
        item.type = AccountType.general.rawValue
        item.userId = "Firebase_User_UUID"
        
        return item
    }
    
    private static func accountGeneral(_ context: NSManagedObjectContext) -> Account {
        let item = Account(context: context)
        item.dateCreated = Calendar.current.date(byAdding: .day, value: 2, to: .now)!
        item.dateModified = .now
        item.id = UUID()
        item.isActive = true
        
        item.icon = ""
        item.name = "Secondary account"
        item.notes = ""
        item.type = AccountType.expenses.rawValue
        item.userId = ""
        
        return item
    }
    
    private static func categoryExpense(_ context: NSManagedObjectContext) -> Category {
        let item = Category(context: context)
        item.dateCreated = .now
        item.dateModified = .now
        item.id = UUID()
        item.isActive = true
        
        item.dateLastUsed = .now
        item.icon = "✅"
        item.name = "Gasto"
        item.type = CategoryType.expense.rawValue
        item.usageCount = 0
        
        return item
    }
    
    private static func categoryIncome(_ context: NSManagedObjectContext) -> Category {
        let item = Category(context: context)
        item.dateCreated = Calendar.current.date(byAdding: .day, value: 2, to: .now)!
        item.dateModified = .now
        item.id = UUID()
        item.isActive = true
        
        item.dateLastUsed = Calendar.current.date(byAdding: .day, value: 1, to: .now)!
        item.icon = "✅"
        item.name = "Ingreso"
        item.type = CategoryType.income.rawValue
        item.usageCount = 1
        
        return item
    }
    
    private static func transactionExpense(_ context: NSManagedObjectContext, category: Category, account: Account) {
        let item = Transaction(context: context)
        item.dateCreated = Calendar.current.date(byAdding: .day, value: 3, to: .now)!
        item.dateModified = .now
        item.id = UUID()
        item.isActive = true
        
        item.amount = 500
        item.dateTransaction = .now
        item.notes = "No notes"
        item.category = category
        item.account = account
    }
    
    private static func transactionIncome(_ context: NSManagedObjectContext, category: Category, account: Account) {
        let item = Transaction(context: context)
        item.dateCreated = Calendar.current.date(byAdding: .day, value: 20, to: .now)!
        item.dateModified = .now
        item.id = UUID()
        item.isActive = true
        
        item.amount = 122343.15
        item.dateTransaction = .now
        item.notes = ""
        item.category = category
        item.account = account
    }
}
