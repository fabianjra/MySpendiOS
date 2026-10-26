//
//  Utils.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 27/6/23.
//

import UIKit
import SwiftUI

struct UtilsUI {
    
    /**
     Get the first window from the scene presented.
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: February 2023
     */
    public static var getFirstWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }?
            .windows
            .first { $0.isKeyWindow }
    }

    /**
     Detects if the app is running on the canvas preview. Mostly used when the code is funcional only when running on device or simulator
     
     **Example:**
     ```swift
     if Utils.isRunningOnCanvasPreview {
     //Do somenthing only when the canvas preview crashes.
     }
     ```
     
     - Returns: true if is running on canvas
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: March 2023
     */
    public static var isRunningOnCanvasPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    
    public static var useAnalytics: Bool {
        if ProcessInfo.processInfo.environment["ignore_analytics"] == "1" {
            return false
        }
        
        return true
    }
    
    /**
     Determines whether the application is running on an iPad.
     
     Uses `UIDevice.current.userInterfaceIdiom` to identify the device's
     interface type and returns `true` when it matches `.pad`.
     
     - Applies to all iPad models, including iPad, iPad mini, iPad Air,
     and iPad Pro.
     - Returns `false` on iPhone, Apple TV, Apple Watch, and other
     devices that do not use the `.pad` interface idiom.
     - Remains `true` on iPad regardless of screen orientation,
     window size, or Split View configuration.
     
     Useful for applying iPad-specific layouts, spacing, padding,
     or other UI customizations in SwiftUI.
     
     - Returns: `true` if the current interface idiom is `.pad`;
     otherwise, `false`.
     */
    public static var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /**
     Determines whether the application is running on an iPhone.

     Uses `UIDevice.current.userInterfaceIdiom` to identify the device's
     interface type and returns `true` when it matches `.phone`.

     - Applies to all iPhone models, regardless of screen size or generation.
     - Returns `false` on iPad, Apple TV, Apple Watch, and other
       devices that do not use the `.phone` interface idiom.
     - Remains `true` on iPhone regardless of screen orientation,
       display size, or interface configuration.
     - Returns `true` on iPod touch devices that use the `.phone` interface idiom.

     Useful for applying iPhone-specific layouts, spacing, padding,
     navigation styles, or other UI customizations in SwiftUI.

     - Returns: `true` if the current interface idiom is `.phone`;
       otherwise, `false`.
     */
    public static var isPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
}
