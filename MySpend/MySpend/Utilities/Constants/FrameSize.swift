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

    var buttonSelectValueIntervalCenter: CGFloat {
        switch self {
        case .width: return 155
        case .height: return 15.0
        }
    }
}
