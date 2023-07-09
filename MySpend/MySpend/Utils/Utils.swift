//
//  Utils.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 27/6/23.
//

import UIKit

struct Utils {
    
    /**
     Get the Interface Orientation device.
     
     **Notes:**
     An application can use more than one scene, each with one or more windows.
     Use the connectedScenes method to obtain the list of connected scenes for the application.
     Use the window or keyWindow property on a scene to obtain the window.
     If you are certain that your app uses only one scene with one window you could obtain the same root view controller using the following:
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: February 2023
     */
    func getUIInterfaceOrientation() -> UIInterfaceOrientation {
        
        //Not deprecated code.
        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .unknown
        }
        
        guard let firstWindow = firstScene.windows.first else {
            return .unknown
        }
        
        return firstWindow.windowScene?.interfaceOrientation ?? .unknown
    }
    
    /**
     Get the root view controller or the presented view controller in case it's called by a Modal.
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: February 2023
     */
    private static func getActualViewController() -> UIViewController? {
        
        //Not deprecated code fot the windowScene.
        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        
        guard let firstWindow = firstScene.windows.first else {
            return nil
        }
        
        //Each ViewController keeps track of the view it has presented,
        //so we can move from the head to the tail, which will always be the current view
        let rootVC = firstWindow.windowScene?.keyWindow?.rootViewController
        
        //If it's a modal, return the presented view controller.
        if rootVC?.presentedViewController != nil {
            return rootVC?.presentedViewController
        } else {
            return rootVC?.children.last
        }
    }
}
