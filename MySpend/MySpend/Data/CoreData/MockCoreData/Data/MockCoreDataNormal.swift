//
//  MocksEntitiesNormal.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 6/7/25.
//

import CoreData

struct MockCoreDataNormal {
    
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Asegura que los fetch vean las inserciones:
        //viewContext.processPendingChanges()
        
        // Accounts:
        let account1 = MockCoreDataNormal.accountMain(viewContext)
        let account2 = MockCoreDataNormal.accountExpenses(viewContext)
        let account3 = MockCoreDataNormal.accountIncomes(viewContext)
        
        // Categories:
        let category1 = MockCoreDataNormal.categoryExpense(viewContext)
        let category2 = MockCoreDataNormal.categoryIncome(viewContext)
        
        // Transactions:
        MockCoreDataNormal.transaction1(viewContext, category: category1, account: account1)
        MockCoreDataNormal.transaction2(viewContext, category: category2, account: account2)
        MockCoreDataNormal.transaction3(viewContext, category: category2, account: account3)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Error al cargar CoreData en: \(String(describing: Self.self)) \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    private static func accountMain(_ context: NSManagedObjectContext) -> Account {
        let item = Account(context: context)
        item.dateCreated = Calendar.current.date(byAdding: .day, value: 1, to: .now)!
        item.dateModified = .now
        item.id = UUID(uuidString: MockCDConstants.mainAccountID)
        item.isActive = true
        
        item.icon = "person.fill"
        item.name = "Main account 1"
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
    
    private static func accountIncomes(_ context: NSManagedObjectContext) -> Account {
        let item = Account(context: context)
        item.dateCreated = Calendar.current.date(byAdding: .day, value: 3, to: .now)!
        item.dateModified = .now
        item.id = UUID()
        item.isActive = true
        
        item.icon = ""
        item.name = "Only incomes"
        item.notes = ""
        item.type = AccountType.incomes.rawValue
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
    
    private static func transaction1(_ context: NSManagedObjectContext, category: Category, account: Account) {
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
    
    private static func transaction2(_ context: NSManagedObjectContext, category: Category, account: Account) {
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
    
    private static func transaction3(_ context: NSManagedObjectContext, category: Category, account: Account) {
        let item = Transaction(context: context)
        item.dateCreated = Calendar.current.date(byAdding: .day, value: 21, to: .now)!
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
