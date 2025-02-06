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
        path.addArc(center: CGPoint(x: rect.midX, y: rect.minY),
                    radius: rect.width / 8,
                    startAngle: .degrees(180),
                    endAngle: .degrees(.zero),
                    clockwise: true)
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        
        path.closeSubpath()
        
        return path
    }
}

struct SemiCircleShapeCurved: Shape {
    func path(in rect: CGRect) -> Path {
        
        let h = rect.maxY * 0.7
        
        var path = Path()
        path.move(to: .zero)
        
        path.addLine(to: CGPoint(x: rect.midX / 2.0, y: rect.minY))
        
        path.addCurve(to: CGPoint(x: rect.midX, y: h),
                      control1: CGPoint(x: rect.midX * 0.8, y: rect.minY),
                      control2: CGPoint(x: rect.midX * 0.7, y: h))
        
        path.addCurve(to: CGPoint(x: rect.midX * 3.0 / 2.0, y: rect.minY),
                      control1: CGPoint(x: rect.midX * 1.3, y: h),
                      control2: CGPoint(x: rect.midX * 1.2, y: rect.minY))
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    ZStack {
        
        Color.backgroundBottom
        
        VStack {
            Color.tabViewBackground
                .clipShape(SemiCircleShape())
                .frame(height: ConstantFrames.tabViewHeight)
        }
        .padding(.bottom, 200)
        
        VStack {
            Color.tabViewBackground
                .clipShape(SemiCircleShapeCurved())
                .frame(height: ConstantFrames.tabViewHeight)
        }
        .padding(.top, 200)
        
    }
}
