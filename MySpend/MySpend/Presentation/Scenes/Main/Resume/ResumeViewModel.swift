//
//  ResumeViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

//import SwiftUI
import FirebaseFirestore

class ResumeViewModel: BaseViewModel {
    
    @Published var model = Resume()
    @Published var showNewTransactionModal = false
    @Published var selectedTab: TabViewIcons = .resume
    @Published var navigateToHistory: Bool = false
    
    //init for previews.
    init(model: Resume = Resume()) {
        self.model = model
    }
    
    private var listener: ListenerRegistration?
    
    func fetchData() {
        
        //#if DEBUG || TARGET_OS_SIMULATOR
        #if targetEnvironment(simulator)
            //No cargar datos cuando se esta corriendo en simulador.
        #else
            //Otra accion en caso de que no sea DEBUG o Simulator. Ejem: Dispositivo fisico.
        #endif
        
        performWithCurrentUser { currentUser in
            self.model.userName = currentUser.displayName ?? ""
            
            let userDocument = UtilsStore.userCollectionReference.document(currentUser.uid)
            
            do {
                self.listener = try Repository().listenDocumentChanges(forModel: UserModel.self, document: userDocument) { [weak self] userLoaded in
                    guard let self = self else {
                        Logs.WriteMessage("GUARD evito crear el listenDocumentChanges ya que no se logro obtener self.")
                        return
                    }
                    
                    model.transactions = userLoaded?.transactions ?? []
                    
                    // Se debe borrar la cantidad en el onAppear porque sino seguria sumandose infinitamente.
                    model.totalBalance = .zero
                    model.totalBalanceFormatted = ConstantCurrency.zeroAmoutString.addCurrencySymbol()
                    
                    for item in model.transactions {
                        model.totalBalance += item.amount
                        model.totalBalanceFormatted = model.totalBalance.convertAmountDecimalToString().addCurrencySymbol()
                    }
                }
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    deinit {
        listener?.remove()
    }
 
    private func testing() {
        
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
