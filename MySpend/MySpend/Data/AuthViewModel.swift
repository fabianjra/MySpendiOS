//
//  AuthViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 29/8/24.
//

import FirebaseAuth

@MainActor
class AuthViewModel : ObservableObject {
    
    @Published var currentUser: User? = Auth.auth().currentUser
    @Published var isLoggedIn: Bool = false
    @Published var user: UserModel? = nil
    
    private var handle : AuthStateDidChangeListenerHandle?
    
    func listenAuthentificationState() {

        handle = Auth.auth().addStateDidChangeListener { [weak self]  auth, user in
            guard let self = self else {
                Logs.WriteMessage("GUARD evito crear el addStateDidChangeListener ya que no se logro obtener self.")
                return
            }
            
            self.currentUser = user
            
            if let user = user {
                self.isLoggedIn = true

                self.user = UserModel(id: user.uid,
                                          fullname: user.displayName ?? "",
                                          email: user.email ?? "",
                                          phoneNumber: user.phoneNumber ?? "",
                                          profilePicture: user.photoURL,
                                          accounts: [],
                                          categories: [])
                
            } else {
                self.isLoggedIn = false
                self.user = nil
            }
        }
    }
    
    func cleanSession() {
        UserDefaultsManager.removeAll()
        
        currentUser = nil
        isLoggedIn = false
        user = nil
        
        if handle != nil {
            Auth.auth().removeStateDidChangeListener(handle!)
            handle = nil
        }
    }
}

//TODO: Pasar a un struct y utilizarlo para mapear el user de Firebase.
//struct UserJSON: Codable {
//    let uid: String
//    let email: String?
//    let displayName: String?
//    let phoneNumber: String?
//    let photoURL: String?
//
//    init(user: User) {
//        self.uid = user.uid
//        self.email = user.email
//        self.displayName = user.displayName
//        self.phoneNumber = user.phoneNumber
//        self.photoURL = user.photoURL?.absoluteString
//    }
//}
