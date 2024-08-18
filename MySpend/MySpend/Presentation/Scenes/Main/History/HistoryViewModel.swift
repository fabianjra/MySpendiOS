//
//  HistoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import Combine

class HistoryViewModel: ObservableObject {
    
    @Published var model: History
    var errorMessage: String = ""
    
    init(model: History = History()) {
        self.model = model
    }
    
    func getTransactions() async {
        
        do {
        //#if DEBUG || TARGET_OS_SIMULATOR
        #if targetEnvironment(simulator)
            //No cargar datos cuando se esta corriendo en simulador.
            model.transactions = try await DatabaseStore.getTransactions()
        #else
            //Otra accion en caso de que no sea DEBUG o Simulator.
            model.transactions = try await DatabaseStore.getTransactions()
        #endif
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
