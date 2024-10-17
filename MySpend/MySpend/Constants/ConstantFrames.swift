//
//  Frames.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/6/23.
//

import UIKit

public struct ConstantFrames {
    static let textFieldHeight: CGFloat = 50.0
    static let dividerHeight: CGFloat = 0.7
    static let screenSize = UIScreen.main.bounds.size
    static let tabViewHeight: CGFloat = 75.0
    static let calendarHeight: CGFloat = 440.0
    
    // MARK: IMAGES
    static let emojiSize: CGFloat = 50.0
    
    // MARK: BUTTONS
    static let roundedButtonIcon: CGFloat = 35.0
}

public enum FrameSize {
    case width
    case height

    var headerButton: CGFloat {
        switch self {
        case .width: return 30.0
        case .height: return 30.0
        }
    }
    
    var navIconCategoryList: CGFloat {
        switch self {
        case .width: return 20.0
        case .height: return 20.0
        }
    }
    
    var tabViewIcon: CGFloat {
        switch self {
        case .width: return 25.0
        case .height: return 25.0
        }
    }
    
    var socialNetwork: CGFloat {
        switch self {
        case .width: return 50.0
        case .height: return 50.0
        }
    }
    
    var checkMarkIcon: CGFloat {
        switch self {
        case .width: return 100.0
        case .height: return 100.0
        }
    }
    
    var loaderFullScreen: CGFloat {
        switch self {
        case .width: return 100.0
        case .height: return 100.0
        }
    }
}
