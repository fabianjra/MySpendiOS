//
//  ToastViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 19/9/26.
//

import Foundation

@Observable
final class ToastViewModel {
    
    var show: Bool = false
    var response = ResponseToast() {
        didSet {
            show = true
        }
    }
    
//    func setResponse(_ text: String, type: ResponseType? = nil) {
//        response = ResponseToast(LocalizedStringResource(stringLiteral: text), type)
//    }
//    
//    func setResponse(_ textLocalized: LocalizedStringResource, type: ResponseType? = nil) {
//        response = ResponseToast(textLocalized, type)
//    }
}
