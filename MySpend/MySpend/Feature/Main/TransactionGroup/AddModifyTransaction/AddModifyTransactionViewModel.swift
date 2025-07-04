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
    
    func onAppear(_ model: TransactionModelFB, selectedDate: Date, isNewTransaction: Bool) {
        if isNewTransaction {
            dateString = selectedDate.toStringShortLocale
        } else {
            dateString = model.dateTransaction.toStringShortLocale
            amountString = model.amount.convertAmountDecimalToString
        }
    }
    
    func addNewTransaction(_ model: TransactionModelFB, selectedDate: Date) async -> ResponseModelFB {
        if model.category.name.isEmptyOrWhitespace {
            return ResponseModelFB(.error, Errors.emptySpaces.localizedDescription)
        }
        
        //Firebase necesita guardar el valor como decimal, pero los formatos del monto en pantalla se trabajan en string:
        var modelMutated = model
        modelMutated.amount = amountString.convertAmountToDecimal
        modelMutated.dateTransaction = selectedDate
        modelMutated.dateCreated = .now
        modelMutated.datemodified = .now
        
        //Not neccesary, but updates the usage counter just in case later could be nedded.
        modelMutated.category.incrementUsedCounter()
        
        let repository = Repository()
        var response = ResponseModelFB()
        
        await performWithLoader { currentUser in
            do {
                modelMutated.userId = currentUser.uid
                
                //TODO: Simplificar llamado. Verificar si queda mejor usando transaccion atomica o haciendo
                //TODO: un llamado armado por medio de query.
                // Updates the category usage counter only if the category still exists in the database.
                if var category = try await CategoriesDatabase().getCategory(forId: modelMutated.category.id) {
                    category.incrementUsedCounter()
                    try await repository.modifyDocument(category, documentId: category.id, forSubCollection: .categories)
                }
                
                let document = try await repository.addNewDocument(modelMutated, forSubCollection: .transactions)
                
                response = ResponseModelFB(.successful, document: document)
            } catch {
                Logs.CatchException(error)
                response = ResponseModelFB(.error, error.localizedDescription)
            }
        }
        
        return response
    }
    
    func modifyTransaction(_ model: TransactionModelFB, selectedDate: Date) async -> ResponseModelFB {
        if model.category.name.isEmptyOrWhitespace {
            return ResponseModelFB(.error, Errors.emptySpaces.localizedDescription)
        }
        
        var modelMutated = model
        modelMutated.dateTransaction = selectedDate
        modelMutated.amount = amountString.convertAmountToDecimal
        modelMutated.datemodified = .now
        
        if modelMutated.dateTransaction.isSameDate(selectedDate) == false {
            modelMutated.dateTransaction = selectedDate
        }
        
        var response = ResponseModelFB()
        
        await performWithLoader {
            do {
                try await Repository().modifyDocument(modelMutated, documentId: modelMutated.id, forSubCollection: .transactions)
                
                response = ResponseModelFB(.successful)
            } catch {
                Logs.CatchException(error)
                response = ResponseModelFB(.error, error.localizedDescription)
            }
        }
        
        return response
    }
    
    func deleteTransaction(_ model: TransactionModelFB) async -> ResponseModelFB {
        var response = ResponseModelFB()
        
        await performWithLoaderSecondary {
            do {
                try await Repository().deleteDocument(model.id, forSubCollection: .transactions)
                
                response = ResponseModelFB(.successful)
            } catch {
                Logs.CatchException(error)
                response = ResponseModelFB(.error, error.localizedDescription)
            }
        }
        
        return response
    }
}
