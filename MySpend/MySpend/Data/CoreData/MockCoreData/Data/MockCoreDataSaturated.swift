//
//  MockCoreDataSaturated.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 22/7/25.
//

import CoreData

struct MockCoreDataSaturated {
    
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Asegura que los fetch vean las inserciones:
        //viewContext.processPendingChanges()
        
        // Accounts:
        for _ in 0..<55 {
            _ = MockCoreDataSaturated.accountMain(viewContext)
            _ = MockCoreDataSaturated.accountExpenses(viewContext)
            _ = MockCoreDataSaturated.accountIncomes(viewContext)
        }
        
        let accountMain = MockCoreDataSaturated.accountMain(viewContext)
        let accountExpenses = MockCoreDataSaturated.accountExpenses(viewContext)
        
        // Categories:
        for counter in 0..<70 {
            _ = MockCoreDataSaturated.categoryExpense(viewContext, counter: counter)
            _ = MockCoreDataSaturated.categoryIncome(viewContext, counter: counter)
        }
        
        let categoryExpense = MockCoreDataSaturated.categoryExpense(viewContext, counter: .zero)
        let categoryIncome = MockCoreDataSaturated.categoryIncome(viewContext, counter: .zero)
        
        // Transactions:
        for counter in 0..<9999 {
            MockCoreDataSaturated.transaction1(viewContext, category: categoryExpense, account: accountExpenses, counter: counter)
            MockCoreDataSaturated.transaction2(viewContext, category: categoryIncome, account: accountMain)
        }
        
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
        item.name = "Main account 1Main account 1Main account 1 Main account 1Main account 1 Main account 1 Main account 1Main account 1 Main account 1 Main account 1"
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
        item.name = "Only expensesOnly expenses Only expenses Only expenses Only expenses Only expenses Only expenses Only expenses Only expenses Only expenses Only expenses Only expenses Only expenses Only expenses Only expenses"
        item.notes = ""
        item.type = AccountType.expenses.rawValue
        item.userId = ""
        
        return item
    }
    
    private static func accountIncomes(_ context: NSManagedObjectContext) -> Account {
        let item = Account(context: context)
        item.dateCreated = Calendar.current.date(byAdding: .day, value: 2, to: .now)!
        item.dateModified = .now
        item.id = UUID()
        item.isActive = true
        
        item.icon = ""
        item.name = "Only incomesincomesincomesincomesincomesincomesincomesincomesincomesincomesincomesincomesincomesincomesincomesincomesincomesincomesincomesincomesincomesincomesincomesincomesincomesincomesincomesincomesincomes"
        item.notes = ""
        item.type = AccountType.incomes.rawValue
        item.userId = ""
        
        return item
    }
    
    private static func categoryExpense(_ context: NSManagedObjectContext, counter: Int) -> Category {
        let item = Category(context: context)
        item.dateCreated = .now
        item.dateModified = .now
        item.id = UUID()
        item.isActive = true
        
        item.dateLastUsed = .now
        item.icon = "✅"
        item.name = "#\(counter): Gasto1Gasto1 Gasto1 Gasto1Gasto1Gasto1 Gasto1 Gasto1 Gasto1 Gasto1Gasto1 Gasto1 Gasto1 Gasto1 Gasto1 Gasto1 Gasto1 Gasto1 Gasto1 Gasto1 Gasto1"
        item.type = CategoryType.expense.rawValue
        item.usageCount = Int64.random(in: 0...9999999)
        
        return item
    }
    
    private static func categoryIncome(_ context: NSManagedObjectContext, counter: Int) -> Category {
        let item = Category(context: context)
        item.dateCreated = Calendar.current.date(byAdding: .day, value: Int.random(in: 0...2), to: .now)!
        item.dateModified = .now
        item.id = UUID()
        item.isActive = true
        
        item.dateLastUsed = Calendar.current.date(byAdding: .day, value: Int.random(in: 0...1), to: .now)!
        item.icon = "✅"
        item.name = "#\(counter): Ingreso-IngresoIngresoIngresoIngresoIngresoIngresoIngresoIngresoIngresoIngresoIngresoIngresoIngreso IngresoIngresoIngresoIngresoIngresoIngresoIngresoIngreso"
        item.type = CategoryType.income.rawValue
        item.usageCount = Int64.random(in: 0...99999)
        
        return item
    }
    
    private static func transaction1(_ context: NSManagedObjectContext, category: Category, account: Account, counter: Int) {
        let item = Transaction(context: context)
        item.dateCreated = Calendar.current.date(byAdding: .day, value: Int.random(in: 0...5), to: .now)!
        item.dateModified = .now
        item.id = UUID()
        item.isActive = true
        
        item.amount = UtilsCurrency.makeNSDecimal(Decimal(Double.random(in: 10.99...7456825682.99)))
        item.dateTransaction = .now
        item.notes = "#\(counter): No notesNo notesNo notesNo notesNo notesNo notesNo notesNo notesNo notesNo notesNo notesNo notesNo notesNo notesNo notes"
        item.category = category
        item.account = account
    }
    
    private static func transaction2(_ context: NSManagedObjectContext, category: Category, account: Account) {
        let item = Transaction(context: context)
        item.dateCreated = Calendar.current.date(byAdding: .day, value: Int.random(in: 0...25), to: .now)!
        item.dateModified = .now
        item.id = UUID()
        item.isActive = true
        
        item.amount = UtilsCurrency.makeNSDecimal(Decimal(Double.random(in: 7456825682.99...1222384567238482347582345343.15)))
        item.dateTransaction = .now
        item.notes = ""
        item.category = category
        item.account = account
    }
}

