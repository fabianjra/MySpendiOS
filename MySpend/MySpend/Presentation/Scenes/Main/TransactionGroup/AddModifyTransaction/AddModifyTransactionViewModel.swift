//
//  AddModifyTransactionViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

import Foundation

class AddModifyTransactionViewModel: BaseViewModel {
    
    @Published var dateString: String = Date.now.toStringShortLocale
    @Published var amountString: String = ""
    
    @Published var showDatePicker = false
    @Published var showCategoryList = false
    @Published var showAlert = false
    
    let notesId = "notes"
    
    func onAppear(_ model: TransactionModel) {
        dateString = model.dateTransaction.toStringShortLocale
        amountString = model.amount.convertAmountDecimalToString
    }
    
    func addNewTransaction(_ model: TransactionModel) async -> ResponseModel {
        if model.category.name.isEmptyOrWhitespace {
            return ResponseModel(.error, Errors.emptySpaces.localizedDescription)
        }
        
        //Firebase necesita guardar el valor como decimal, pero los formatos del monto en pantalla se trabajan en string:
        var modelMutated = model
        modelMutated.amount = amountString.convertAmountToDecimal
        modelMutated.dateCreated = .now
        modelMutated.datemodified = .now
        
        var response = ResponseModel()
        
        await performWithLoader { currentUser in
            do {
                modelMutated.userId = currentUser.uid
                
                try await Repository().addNewDocument(modelMutated, forSubCollection: .transactions)
                
                response = ResponseModel(.successful)
            } catch {
                Logs.WriteCatchExeption(error: error)
                response = ResponseModel(.error, error.localizedDescription)
            }
        }
        
        return response
    }
    
    func modifyTransaction(_ model: TransactionModel) async -> ResponseModel {
        if model.category.name.isEmptyOrWhitespace {
            return ResponseModel(.error, Errors.emptySpaces.localizedDescription)
        }
        
        var modelMutated = model
        modelMutated.amount = amountString.convertAmountToDecimal
        modelMutated.datemodified = .now
        
        var response = ResponseModel()
        
        await performWithLoader {
            do {
                try await Repository().modifyDocument(modelMutated, documentId: modelMutated.id, forSubCollection: .transactions)
                
                response = ResponseModel(.successful)
            } catch {
                Logs.WriteCatchExeption(error: error)
                response = ResponseModel(.error, error.localizedDescription)
            }
        }
        
        return response
    }
    
    func deleteTransaction(_ model: TransactionModel) async -> ResponseModel {
        var response = ResponseModel()
        
        await performWithLoaderSecondary {
            do {
                try await Repository().deleteDocument(model.id, forSubCollection: .transactions)
                
                response = ResponseModel(.successful)
            } catch {
                Logs.WriteCatchExeption(error: error)
                response = ResponseModel(.error, error.localizedDescription)
            }
        }
        
        return response
    }
}
