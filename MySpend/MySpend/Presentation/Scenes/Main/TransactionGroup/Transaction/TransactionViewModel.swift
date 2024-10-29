//
//  TransactionViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import FirebaseFirestore

class TransactionViewModel: BaseViewModel {
    
    @Published var userName: String = ""
    @Published var dateTimeInvertal: DateTimeInterval = .month
    
    // MARK: TRANSACTIONS
    @Published var transactions: [TransactionModel]
    
    @Published var groupedTransactions: [(category: CategoryModel, totalAmount: Decimal)] = []
    @Published var totalBalance: Decimal = .zero
    @Published var totalBalanceFormatted: String = ConstantCurrency.zeroAmoutString.addCurrencySymbol()

    
    //init for Canvas Previews.
    init(transactions: [TransactionModel] = []) {
        self.transactions = transactions
    }
    
    func onAppear() {
        performWithCurrentUser { currentUser in
            guard let displayName = currentUser.displayName else { return }
            self.userName = displayName
        }
    }
    
    private var listener: ListenerRegistration?
    
    deinit {
        listener?.remove()
    }
    
    func fetchData() {
        
        //#if DEBUG || TARGET_OS_SIMULATOR
#if targetEnvironment(simulator)
        //No cargar datos cuando se esta corriendo en simulador.
#else
        //Otra accion en caso de que no sea DEBUG o Simulator. Ejem: Dispositivo fisico.
#endif
        
        performWithCurrentUser { currentUser in
            let collectionRef = UtilsFB.userSubCollectionRef(.transactions, for: currentUser.uid)
            
            self.listener = ListenersFB().listenCollectionChanges(collection: collectionRef) { [weak self] documentsChange, error in
                
                guard let self = self else {
                    Logs.WriteMessage("Guard evito crear el listener ya que no se logro obtener self")
                    return
                }
                
                if let error = error {
                    errorMessage = error.localizedDescription
                    Logs.WriteCatchExeption(error: error)
                    return
                }
                
                //TODO: Revisar:
                /*
                 Revisar la implementacion de un Protocol HasStringID para los modelos de CategoryModel y TransactionModel y asi hacer todo generico del lado del ListenersFB().
                 El problema es que se pasaria un array para modificarlo del otro lado, lo que implica pasar un ValueType y es inmutable,
                 por lo que se tendria que crear una copia del otro lado y devolver esa copia para hacerle encima al array de este ViewModels.
                 Lo mejor es dejarlo como esta por ahora, ya que crear una instancia nueva del array en el otro lado impica costo de rendimiento, ya que seria en cada cambio.
                 */
                if documentsChange.isEmpty {
                    transactions.removeAll()
                } else {
                    for change in documentsChange {
                        switch change.type {
                            
                            //La primera vez que se llama al listener, se reciben todos los documentos como "added", y después solo se reciben las diferencias.
                        case .added:
                            let data = change.document.data()
                            let decodedDocument = try? UtilsFB.decodeModelFB(data: data, forModel: TransactionModel.self)
                            
                            if var decodedDocument = decodedDocument {
                                
                                //Permite validar que no se dupliquen items.
                                if !transactions.contains(where: { $0.id == change.document.documentID }) {
                                    decodedDocument.id = change.document.documentID
                                    transactions.append(decodedDocument)
                                }
                            }
                            
                        case .modified:
                            if let index = transactions.firstIndex(where: { $0.id == change.document.documentID }) {
                                let data = change.document.data()
                                
                                if var decodedDocument = try? UtilsFB.decodeModelFB(data: data, forModel: TransactionModel.self) {
                                    decodedDocument.id = change.document.documentID
                                    transactions[index] = decodedDocument
                                } else {
                                    Logs.WriteMessage("Error al decodificar el documento y pasarlo al Modelo")
                                }
                            }
                            
                        case .removed:
                            transactions.removeAll(where: { $0.id == change.document.documentID })
                            
                        default:
                            Logs.WriteMessage("Nothing modified in the documentChange")
                        }
                    }
                }
                
                calculateGroupedTransactions()
                calculateTotalBalance()
            }
        }
        
        // Only to show Mock values on the Canvas Preview.
        if Utils.isRunningOnCanvasPreview() {
            calculateGroupedTransactions()
            calculateTotalBalance()
        }
    }
    
    /**
     Esta función agrupa las transacciones por category.id y luego calcula el monto total de cada grupo.
     El resultado se guarda en la variable groupedTransactions, que es una lista de tuplas con el modelo de categoría y el monto total.
    */
    private func calculateGroupedTransactions() {
        let grouped = Dictionary(grouping: transactions) { $0.category.id }
        
        groupedTransactions = grouped.compactMap { (categoryId, transactions) -> (CategoryModel, Decimal)? in
            guard let firstTransaction = transactions.first else
            {
                return nil
            }
            
            let totalAmount = transactions.reduce(Decimal.zero) { $0 + $1.amount }
            return (firstTransaction.category, totalAmount)
        }
    }
    
    /**
     Esta función filtra las transacciones por transactionType, sumando los ingresos (income) y los gastos (expense).
     Luego, calcula el balance final restando los gastos a los ingresos y formatea el balance.
     */
    private func calculateTotalBalance() {
        let totalIncome = transactions
            .filter { $0.transactionType == .income }
            .reduce(Decimal.zero) { $0 + $1.amount }
        
        let totalExpenses = transactions
            .filter { $0.transactionType == .expense }
            .reduce(Decimal.zero) { $0 + $1.amount }
        
        totalBalance = totalIncome - totalExpenses
        totalBalanceFormatted = totalBalance.convertAmountDecimalToString().addCurrencySymbol()
    }
    
    
    //TODO: Implementar o borrar.
    private func PREUBAS_CAMPOS_DE_FIREBASE() {
        
        let authViewModel = AuthViewModel()
        
        if let user = authViewModel.currentUser {
            
            // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with your backend server,
            // if you have one. Use getTokenWithCompletion:completion: instead.
            
            let _: String = user.providerID
            let _: String = user.uid
            let _: String? = user.displayName
            let _: URL? = user.photoURL
            let _: String? = user.email
            
            var multiFactorString = "MultiFactor: "
            for info in user.multiFactor.enrolledFactors {
                multiFactorString += info.displayName ?? "[DispayName]"
                multiFactorString += " "
            }
        }
    }
}
