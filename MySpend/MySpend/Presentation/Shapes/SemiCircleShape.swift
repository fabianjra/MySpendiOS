//
//  SemiCircleShape.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/7/23.
//

import SwiftUI

/**
 Half of a circle clip shape for a view. Must be used in the modifier ".clipShape".
 
 **Example:**
 ```swift
 Color.white
     .frame(width: 100, height: 100)
     .clipShape(SemiCircleShape())
 ```
 
 - Returns: Shape
 
 - Authors: Fabian Rodriguez
 
 - Version: 1.0
 
 - Date: June 2023
 */
struct SemiCircleShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.minY), radius: rect.width / 8, startAngle: .degrees(180), endAngle: .degrees(.zero), clockwise: true)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.closeSubpath()
        
        return path
    }
}
