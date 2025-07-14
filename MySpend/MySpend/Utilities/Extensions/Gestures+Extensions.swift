//
//  Gestures+Extensions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/7/23.
//

import UIKit

//Controls the state to enable or disable swipe to go back on Views.
class AppState {
    static let shared = AppState()

    //True by default. Can swipe back in every view, until it's setted to false.
    var swipeEnabled = true
}

//Code taken from here: https://stackoverflow.com/a/75661073/7116544
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if AppState.shared.swipeEnabled {
            return viewControllers.count > 1
        }
        return false
    }
}


extension UIApplication: UIGestureRecognizerDelegate {
    
    /**
     Tap anywhere to hide the keyboard:
     Here is an updated solution for SwiftUI 2 / iOS 14 (originally proposed here by Mikhail).
     It doesn't use the AppDelegate nor the SceneDelegate which are missing if you use the SwiftUI lifecycle:
     
     **Notes:**
     - Code taken from: https://stackoverflow.com/a/63942065/7116544
     
     **Example:**
     ```swift
     @main
     struct TestApp: App {
         var body: some Scene {
             WindowGroup {
                 MainContenidoView()
                     .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
             }
         }
     }
     ```
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: Jul 2025
     */
    func addTapGestureRecognizer() {
        guard let window = UtilsUI.getFirstWindow else { return }
        
        let tap = UITapGestureRecognizer(target: window,
                                         action: #selector(UIView.endEditing))
        tap.requiresExclusiveTouchType = false
        tap.cancelsTouchesInView       = false
        tap.delegate                   = self // delegate
        window.addGestureRecognizer(tap)
    }
    
    // Sólo dimite el teclado cuando se toca "fuera" de un control interactivo
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        switch touch.view {
            
        // Lista de controles que no deben cerrar el teclado al presionarse:
        case is UISegmentedControl,
            is UISwitch,
            //is UIButton, // Si debe cerrarse porque al presionar el Modificar, agregar, etc. Se va a mostra abajo un mensaje de error en caso de que exista
            is UIControl:
            return false // ❌ no cerrar teclado
            
        default:
            return true // ✅ dimitir teclado
        }
    }
}
