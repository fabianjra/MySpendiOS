//
//  FrameSize.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 23/10/24.
//

import Foundation

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