//
//  MocksEntitiesNormal.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 6/7/25.
//

import Foundation
import CoreData

struct MockCoreDataNormal {
    
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Asegura que los fetch vean las inserciones:
        //viewContext.processPendingChanges()
        
        // Accounts:
        let accountMain = MockCoreDataNormal.accountMain(viewContext)
        let accountGeneral = MockCoreDataNormal.accountExpenses(viewContext)
        
        // Categories:
        let categoryExpense = MockCoreDataNormal.categoryExpense(viewContext)
        let categoryIncome = MockCoreDataNormal.categoryIncome(viewContext)
        
        // Transactions:
        MockCoreDataNormal.transactionExpense(viewContext, category: categoryExpense, account: accountMain)
        MockCoreDataNormal.transactionExpense(viewContext, category: categoryIncome, account: accountMain)
        
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
        item.id = UUID(uuidString: MockCDConstants.mainAccountID)
        //item.id = UUID()
        item.isActive = true
        
        item.icon = "person.fill"
        item.name = "Main account"
        item.notes = "No notes"
        item.type = AccountType.general.rawValue
        item.userId = "Firebase_User_UUID"
        
        return item
    }
    
    private static func accountExpenses(_ context: NSManagedObjectContext) -> Account {
        let item = Account(context: context)
        item.dateCreated = Calendar.current.date(byAdding: .day, value: 2, to: .now)!
        item.dateModified = .now
        item.id = UUID()
        item.isActive = true
        
        item.icon = ""
        item.name = "Only expenses"
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
