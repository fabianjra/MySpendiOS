//
//  Utils.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 27/6/23.
//

import UIKit
import SwiftUI

struct Utils {
    
    /**
     Get the Interface Orientation device.
     
     **Notes:**
     - An application can use more than one scene, each with one or more windows.
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
     Get the first window from the scene presented.
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: February 2023
     */
    static func getFirstWindow() -> UIWindow? {
        
        //Not deprecated code fot the windowScene:
        //'windows' was deprecated in iOS 15.0: Use UIWindowScene.windows on a relevant window scene instead
        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        
        guard let firstWindow = firstScene.windows.first else {
            return nil
        }
        
        return firstWindow
    }
    
    /**
     Get the root view controller or the presented view controller in case it's called by a Modal.
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: February 2023
     */
    static func getActualViewController() -> UIViewController? {

        guard let firstWindow = getFirstWindow() else { return nil }
        
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
    
    /**
     Detects if the app is running on the canvas preview. Mostly used when the code is funcional only when running on device or simulator
     
     **Example:**
     ```swift
     if Utils.isRunningOnCanvasPreview() {
         //Do somenthing only when the canvas preview crashes.
     }
     ```
     
     - Returns: true if is running on canvas
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: March 2023
     */
    static func isRunningOnCanvasPreview() -> Bool {
        
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            return true
        } else {
            return false
        }
    }
    
    /**
     Get the size of each edge insets: Top size, Left size, Right size and Bottom size.
     
     **Notes:**
     - If it is zero: it is iPhone SE, 8, 7 or 6.
     
     **Example:**
     ```swift
     VStack {
         //View
     }
     .padding(.bottom, Utils.getEdgeInsets().bottom == .zero ? 10 : .zero) //Add padding when is iPhone SE screen.
     ```
     
     - Returns: The size of each edge insets (top, left, right and bottom).
     
     - Authors: Fabian Rodriguez.
     
     - Date: May 2023
     */
    static func getEdgeInsets() -> UIEdgeInsets {
        return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first(where: {$0.isKeyWindow})?.safeAreaInsets ?? .zero
    }
    
    static func deviceHasNotch() -> Bool {
        return getEdgeInsets().bottom != .zero
    }
    
    /**
     Convert a given date to string in short format: dd/MM/yyy. Ejem: 29/05/1990
     
     **Example:**
     ```swift
     DatePicker(selection: $selectedDate, displayedComponents: .date) {
         
     }
     .onChange(of: selectedDate, perform: { _ in

         dateString = Utils.dateToStringShort(date: selectedDate)
         
         let day = selectedDate.formatted(.dateTime.day())
     })
     ```
     
     - Returns: String short date: dd/MM/yyy
     
     - Authors: Fabian Rodriguez.
     
     - Date: Sep 2023
     */
    static func dateToStringShort(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_CR")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    static func stringShortDateToDate(dateShort: String) -> Date {
        let dateFormatter = DateFormatter()
        //dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.locale = Locale(identifier: "es_CR")
        dateFormatter.dateFormat = "dd/MM/yyy"
        let date = dateFormatter.date(from:dateShort) ?? .now
        return date
    }
    
    /// Get an FavIcon from a string text.
    /// Example: envelope.fill
    /// - Parameter iconName: SB Symbol Image name
    /// - Returns: SwiftUI Image
    static func getIconFromString(_ iconName: String?) -> Image? {
        if let systemName = iconName {
            if systemName.isEmptyOrWhitespace() {
                return nil
            } else {
                return Image(systemName: systemName)
            }
        }
        return nil
    }
}
