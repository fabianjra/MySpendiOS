//
//  TransactionViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import Combine
import CoreData

class TransactionViewModel: BaseViewModel {
    
    private let viewContext: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()
    
    @Published var userName: String = "Generic user"
    @Published var dateTimeInterval = UserDefaultsManager.dateTimeInterval
    
    @Published var transactions: [TransactionModel] = []
    @Published var groupedTransactions: UtilsCurrency.groupedTransactions = []
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
        super.init() // Se debe llamar primero a super porque se utiliza self en el subscribe heredando del BaseViewModel.
        subscribeToViewContextChanges()
    }
    
    private func subscribeToViewContextChanges() {
        NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange, object: viewContext)
            .sink { [weak self] _ in
                self?.fetchAll()
            }
            .store(in: &cancellables)
    }
    
    func fetchAll() {
        do {
            transactions = try TransactionManager(viewContext: viewContext).fetchAll()
            groupedTransactions = UtilsCurrency.calculateGroupedTransactions(transactions)
        } catch {
            Logs.CatchException(error, type: .CoreData)
        }
    }
}
