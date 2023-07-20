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
