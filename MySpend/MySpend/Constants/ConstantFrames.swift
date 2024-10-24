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
    static let toolbarNavigationBarHeight: CGFloat = 55.0
    
    // MARK: IMAGES
    static let emojiSize: CGFloat = 50.0
    
    // MARK: BUTTONS
    static let roundedButtonIcon: CGFloat = 35.0
    
    // MARK: IPAD
    static let iPadMaxWidth: CGFloat = 500.0
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
    
    var iconCategoryList: CGFloat {
        return 20.0
    }

    var tabViewIcon: CGFloat {
        return 25.0
    }

    var socialNetwork: CGFloat {
        return 50.0
    }
    
    var checkMarkIcon: CGFloat {
        return 100.0
    }
    
    var loaderFullScreen: CGFloat {
        return 100.0
    }

    var iconSelect: CGFloat {
        return 50.0
    }

    var iconShowcase: CGFloat {
        return 30.0
    }
    
    var iconInsideTextField: CGFloat {
        return 25.0
    }
}
