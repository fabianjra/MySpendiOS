//
//  Gestures+Extensions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/7/23.
//

import UIKit

extension UIApplication {
    
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
    private static let keyboardDismissGestureDelegate = KeyboardDismissGestureDelegate()
    
    func addTapGestureRecognizer() {
        guard let window = UtilsUI.getFirstWindow else {
            return
        }
        
        let tap = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        
        tap.requiresExclusiveTouchType = false
        tap.cancelsTouchesInView = false
        tap.delegate = Self.keyboardDismissGestureDelegate
        
        window.addGestureRecognizer(tap)
    }
}

final class KeyboardDismissGestureDelegate: NSObject, UIGestureRecognizerDelegate {
    
    // Sólo oculta el teclado cuando se toca "fuera" de un control interactivo
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        switch touch.view {
            
        case is UISegmentedControl,
            is UISwitch,
            //is UIButton, // Si debe ocultarse porque al presionar el Modificar, agregar, etc. Se va a mostra abajo un mensaje de error en caso de que exista
            is UIControl:
            return false // NO ocultar teclado.
            
        default:
            return true // SI ocultar teclado
        }
    }
}
