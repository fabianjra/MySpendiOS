//
//  ResumeViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import SwiftUI

class ResumeViewModel: BaseViewModel {
    
    @Published var model = Resume()
    
    init(model: Resume = Resume()) {
        self.model = model
    }

    func onAppear(_ authViewModel: AuthViewModel) async {
        if let user = authViewModel.currentUser {
            
            // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with your backend server,
            // if you have one. Use getTokenWithCompletion:completion: instead.
            
            let _: String = user.providerID
            let _: String = user.uid
            let displayName: String? = user.displayName
            let _: URL? = user.photoURL
            let _: String? = user.email
            
            var multiFactorString = "MultiFactor: "
            for info in user.multiFactor.enrolledFactors {
                multiFactorString += info.displayName ?? "[DispayName]"
                multiFactorString += " "
            }
            
            model.userName = displayName ?? ""
            
            await getTransactions()
        }
    }
    
    private func getTransactions() async {
        
        do {
        //#if DEBUG || TARGET_OS_SIMULATOR
        #if targetEnvironment(simulator)
            //No cargar datos cuando se esta corriendo en simulador.
            model.transactions = try await DatabaseStore().getTransactions()
        #else
            //Otra accion en caso de que no sea DEBUG o Simulator.
            model.transactions = try await DatabaseStore().getTransactions()
        #endif
            
            model.totalBalance = 0
            for item in model.transactions {
                model.totalBalance += item.amount
            }
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
