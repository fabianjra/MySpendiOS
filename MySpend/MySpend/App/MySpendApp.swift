//
//  MySpendApp.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/6/23.
//

import SwiftUI
import Firebase
import SwiftData

//Resolve warning: [GoogleUtilities/AppDelegateSwizzler][I-SWZ001014] App Delegate does not conform to UIApplicationDelegate protocol.
//It is not a good idea to go back to AppDelegate.

//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        FirebaseApp.configure()
//        return true
//    }
//}

@main
struct MySpendApp: App {
    
    // Confire the cointainer for Database
    let container: ModelContainer = {
        let container : ModelContainer
        
        let schema = Schema([UserModel.self,
                             AccountModel.self,
                             AccountModel.self,
                             TransactionModel.self,
                             CategoryModel.self])
        
        let config = ModelConfiguration("MySpendModelSchema",
                                        schema: schema,
                                        isStoredInMemoryOnly: false,
                                        allowsSave: true)
        
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Fallo al inicializar el contenedor de datos") //TODO: Refactorizar
        }

        return container
    }()
    
    //Evitar error que no permite cargar Firebase:
    //@StateObject var dataManager = DataManager() //Class for get, add and delete from Firestore.
    
    // register app delegate for Firebase setup
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
    //Se agrega la dependencia de Firebase aqui, ya que este archivo realiza la misma funcion que en el AppDelegate.
    init() {
        //FirebaseConfiguration.shared.setLoggerLevel(.min) //Evitar mensajes de firebase innecesarios.
        FirebaseApp.configure()
        
        // Debug: Shows the diretory path for the Database
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
    
    @StateObject var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .modelContainer(container)
                .environmentObject(authViewModel)
                //.environmentObject(dataManager) //Class for get, add and delete from Firestore.
        }
    }
}
