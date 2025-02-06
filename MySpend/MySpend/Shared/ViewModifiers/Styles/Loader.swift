//
//  Loader.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/23.
//

import SwiftUI

struct Loader: View {
    
    @State private var isAnimating: Bool = false
    
    var body: some View {
        
        GeometryReader { (geometry: GeometryProxy) in
            
            ForEach(0..<5) { index in
                
                Group {
                    Circle()
                        .frame(width: geometry.size.width / 5, height: geometry.size.height / 5)
                        .scaleEffect(calcScale(index: index))
                        .offset(y: calcYOffset(geometry))
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .rotationEffect(!isAnimating ? .degrees(.zero) : .degrees(360))
                .animation(Animation.timingCurve(0.5, 0.15 + Double(index) / 5,
                                                     0.25, 1,
                                                     duration: 1.5)
                        .repeatForever(autoreverses: false), value: isAnimating)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            isAnimating = true
        }
    }
    
    func calcScale(index: Int) -> CGFloat {
        return (!isAnimating ? 1 - CGFloat(Float(index)) / 5 : 0.2 + CGFloat(index) / 5)
    }
    
    func calcYOffset(_ geometry: GeometryProxy) -> CGFloat {
        return geometry.size.width / 10 - geometry.size.height / 2
    }
}


#Preview {
    @Previewable @State var showLoader: Bool = true
    VStack {
        
        ZStack {
            LinearGradient(colors: Color.primaryGradiant,
                           startPoint: .leading,
                           endPoint: .trailing)
            .mask(Loader()
                .frame(width: 200, height: 200))
        }
        
        
        Button("Show loader") {
            showLoader.toggle()
        }
        .buttonStyle(ButtonPrimaryStyle(isLoading: $showLoader))
        
        
        Loader()
            .frame(width: 200, height: 200)
            .foregroundColor(Color.textPrimaryForeground)
        
        
        ProgressView()
            .tint(Color.textPrimaryForeground)
    }
    .background(Color.backgroundBottom)
}
