//
//  Frames.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/6/23.
//

import UIKit

struct Frames {
    static let textFieldHeight: CGFloat = 50.0
    static let dividerHeight: CGFloat = 0.7
    static let screenSize = UIScreen.main.bounds.size
    static let tabViewIcon: CGFloat = 20.0
    static let tabViewHeight: CGFloat = 75.0
    
    //MARK: BUTTON
    static let roundedButtonIcon: CGFloat = 35.0
}

enum FrameSize {
    case width
    case height
    
    var buttonBack: CGFloat {
        switch self {
        case .width: return 15.0
        case .height: return 30.0
        }
    }
}
