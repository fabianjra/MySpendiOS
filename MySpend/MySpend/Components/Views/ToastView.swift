//
//  ToastView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 19/9/26.
//

import SwiftUI

private struct ToastView: ViewModifier {
    @Binding var response: ToastResponse?
    @State private var isPresented = false
    
    // Tiempo en segundos que se mostrara el Popup. Se calcula por palabra
    private var displayDuration: Double {
        let message = String(localized: response?.message ?? "")
        let wordCount = message.split(whereSeparator: \.isWhitespace).count
        let readingTime = Double(wordCount) / 225.0 * 60.0

        return min(max(readingTime, 3.0), 6.0)
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if isPresented {
                    
                    HStack {
                        Text(response?.type?.rawValue ?? "")
                        
                        Text(response?.message ?? "")
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
                            response = nil
                        }
                    }
                    
                    .task(id: response != nil && isPresented) {
                        guard isPresented else { return }

                        try? await Task.sleep(for: .seconds(displayDuration))

                        // Al ignorar el error de cancelación, una tarea cancelada puede continuar inmediatamente y ocultar un toast más reciente.
                        // Por eso es importante esta linea de codigo.
                        guard !Task.isCancelled else { return }

                        withAnimation {
                            isPresented = false
                            response = nil
                        }
                    }
                }
            }
            .animation(.easeInOut, value: isPresented)
        
            .onChange(of: response != nil, initial: true) { _, hasResponse in
                if hasResponse {
                    withAnimation {
                        isPresented = true
                    }
                }
            }
    }
}

extension View {    
    func toast(_ response: Binding<ToastResponse?>) -> some View {
        modifier(ToastView(response: response))
    }
}

#Preview {
    @Previewable @State var toastResponse: ToastResponse?
    
    VStack {
        Spacer()
        
        Button("View Toast small") {
            toastResponse = ToastResponse(.responseSuccesful, .ok)
        }
        
        HStack {
            Spacer()
        }
        
        Spacer()
        
        Button("View Toast Big") {
            toastResponse = ToastResponse(LocalizedStringResource(stringLiteral:
                                                                    Errors.cannotUpdateAccountWithTransactions("TEST").localizedDescription), .error)
        }
        
        Spacer()
        
        Button("View Toast Error") {
            toastResponse = ToastResponse(.responseErrorTextFieldEmptySpace, .error)
        }
        
        Spacer()
    }
    .background(Color.backgroundGradient)
    .toast($toastResponse)
}
