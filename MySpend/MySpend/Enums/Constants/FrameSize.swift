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
        return 30.0
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
    
    var selectIconInsideTextField: CGFloat {
        return 23.0
    }
    
    var iconAddNewData: CGFloat {
        return 150.0
    }
    
    var buttonToolbarEditList: CGFloat {
        return 45.0
    }
    
    var buttonSelectValueInterval: CGFloat {
        return 20.0
    }
    
    var rowMenuText: CGFloat {
        return 50.0
    }
    
    var loaderSquareBackground: CGFloat {
        return 350.0
    }
    
    var calendar: CGFloat {
        switch self {
        case .width: return 320.0
        case .height: return 440.0
        }
    }

    var buttonSelectValueIntervalCenter: CGFloat {
        switch self {
        case .width: return 170
        case .height: return 15.0
        }
    }
    
    var rowForListTransactionHistory: CGFloat {
        switch self {
        case .width: return ConstantFrames.iPadMaxWidth
        case .height: return 40.0
        }
    }
}
