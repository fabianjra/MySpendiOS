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
    
    func onAppear(_ model: TransactionModel, selectedDate: Date, isNewTransaction: Bool) {
        if isNewTransaction {
            dateString = selectedDate.toStringShortLocale
        } else {
            dateString = model.dateTransaction.toStringShortLocale
            amountString = model.amount.convertAmountDecimalToString
        }
    }
    
    func addNewTransaction(_ model: TransactionModel, selectedDate: Date) async -> ResponseModel {
        if model.category.name.isEmptyOrWhitespace {
            return ResponseModel(.error, Errors.emptySpaces.localizedDescription)
        }
        
        //Firebase necesita guardar el valor como decimal, pero los formatos del monto en pantalla se trabajan en string:
        var modelMutated = model
        modelMutated.amount = amountString.convertAmountToDecimal
        modelMutated.dateTransaction = selectedDate
        modelMutated.dateCreated = .now
        modelMutated.datemodified = .now
        
        var categoryMutated = model.category
        categoryMutated.dateLastUsed = .now
        
        var response = ResponseModel()
        
        await performWithLoader { currentUser in
            do {
                modelMutated.userId = currentUser.uid
                
                let repository = Repository()

                let document = try await repository.addNewDocument(modelMutated, forSubCollection: .transactions)
                try await repository.modifyDocument(categoryMutated, documentId: categoryMutated.id, forSubCollection: .categories)
                
                response = ResponseModel(.successful, document: document)
            } catch {
                Logs.WriteCatchExeption(error: error)
                response = ResponseModel(.error, error.localizedDescription)
            }
        }
        
        return response
    }
    
    func modifyTransaction(_ model: TransactionModel, selectedDate: Date) async -> ResponseModel {
        if model.category.name.isEmptyOrWhitespace {
            return ResponseModel(.error, Errors.emptySpaces.localizedDescription)
        }
        
        var modelMutated = model
        modelMutated.dateTransaction = selectedDate
        modelMutated.amount = amountString.convertAmountToDecimal
        modelMutated.datemodified = .now
        
        if modelMutated.dateTransaction.isSameDate(selectedDate) == false {
            modelMutated.dateTransaction = selectedDate
        }
        
        var categoryMutated = model.category
        categoryMutated.dateLastUsed = .now
        
        var response = ResponseModel()
        
        await performWithLoader {
            do {
                let repository = Repository()
                
                try await repository.modifyDocument(modelMutated, documentId: modelMutated.id, forSubCollection: .transactions)
                try await repository.modifyDocument(categoryMutated, documentId: categoryMutated.id, forSubCollection: .categories)
                
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
