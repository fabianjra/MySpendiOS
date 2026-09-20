//
//  ToastView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 19/9/26.
//

import SwiftUI

private struct ToastView: ViewModifier {
    let response: ResponseToast
    @Binding var isPresented: Bool
    
    // Tiempo en segundos que se mostrara el Popup. Se calcula por palabra
    private var displayDuration: Double {
        let message = String(localized: response.message)
        let wordCount = message.split(whereSeparator: \.isWhitespace).count
        let readingTime = Double(wordCount) / 225.0 * 60.0

        return min(max(readingTime, 3.0), 6.0)
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if isPresented {
                    
                    HStack {
                        Text(response.type?.rawValue ?? "")
                        
                        Text(response.message)
                            .fontDesign(.rounded)
                            .lineLimit(ConstantViews.toastMessageMaxLines)
                    }
                    .padding(.horizontal)
                    .padding(.vertical)
                    .background(.ultraThinMaterial)
                    .clipShape(.capsule)
                    .padding(.bottom)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    
                    .onTapGesture {
                        withAnimation {
                            isPresented = false
                        }
                    }
                    
                    .task {
                        try? await Task.sleep(for: .seconds(displayDuration))
                        
                        withAnimation {
                            isPresented = false
                        }
                    }
                }
            }
            .animation(.easeInOut, value: isPresented)
    }
}

extension View {
    func toast(_ response: ResponseToast, isPresented: Binding<Bool>) -> some View {
        modifier(ToastView(response: response, isPresented: isPresented))
    }
}

#Preview {
    @Previewable @State var toast = ToastViewModel()
    
    VStack {
        Spacer()
        
        Button("View Toast small") {
            toast.setResponse(.responseSuccesful, type: .ok)
        }
        
        HStack {
            Spacer()
        }
        
        Spacer()
        
        Button("View Toast Big") {
            toast.setResponse(Errors.cannotUpdateAccountWithTransactions("TEST").localizedDescription, type: .ok)
        }
        
        Spacer()
        Button("View Toast Error") {
            toast.setResponse(.responseErrorTextFieldEmptySpace, type: .error)
        }
        
        Spacer()
    }
    .background(Color.backgroundGradient)
    .toast(toast.response, isPresented: $toast.show)
}
