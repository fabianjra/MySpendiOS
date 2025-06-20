//
//  Logs.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/7/23.
//

import Foundation

enum Logs {
    
    /**
     Shows a Catch error message on console, and an optional string message.
     
     **Notes:**
     - This function takes the file name where the error is presented, the function name who call it and the line number where the error is presented.
     - By default **file**, **function** and **line** are setted internally, so you can ignore these parameters.
     
     **Example:**
     ```swift
     do{
        let article = try JSONDecoder().decode(T.self, from: data)
     
        if let article = article {
            completion(article)
        }
        }catch{
            Logs.WriteCatchExeption(err: error)
     }
     ```
     
     - Parameters:
        - message:Optional string message to add to the print.
        - error: The catch error message from the try.
     
     - Returns: Void
     
     - Warning: N/A
     
     - Throws: N/A
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: February 2023
     */
    static func WriteCatchExeption(_ message: String? = nil, file: String = #file, function: String = #function, line: Int = #line, error: Error) {
        print("MYSPEND Handled catch error: \(message ?? ""), called by: \(file.components(separatedBy: "/").last ?? file) - \(function), at line: \(line). Description: ", error)
    }
    
    /**
     Shows a message on console.
     
     **Notes:**
     - Writes a simple string message on console.
     
     **Example:**
     ```swift
        Logs.WriteMessage("This is a string message.")
     ```
     
     - Parameters:
        - message:String message to add to the print.
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: February 2023
     */
    static func WriteMessage(_ obj: Any) {
        print("///************************** CUSTOM MESSSAGE **************************///")
        print(obj)
        print("///************************ END CUSTOM MESSSAGE ************************///")
    }
    
    /**
     Creates a customizable `NSError` instance.
     This function allows you to create an `NSError` with a specific domain, code,
     user info dictionary, and custom description. It is useful for creating standardized
     error objects throughout your application.
     
     **Example:**
     ```swift
     let customError = UtilsStore.createCustomNSError(domain: "com.yourapp.network",
                                                      code: 404,
                                                      userInfo: ["key": "value"],
                                                      description: "The requested resource was not found.")
     ```
     
     - Parameters:
        - domain: A string indicating the domain of the error. This should describe the error's general source, such as `"com.yourapp.network".
        - code: An integer representing the error code. This is typically a unique value for the specific type of error within the domain.
        - userInfo: A dictionary containing key-value pairs that provide additional information about the error. For example, this could include localized error descriptions or recovery suggestions.
        - description: A  description string that can be added to the user info dictionary under the `NSLocalizedDescriptionKey` to describe the error.
     
     - Returns: A fully customized `NSError` instance with the provided parameters.
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: Aug 2024
     */
    static func createError(domain: ErrorDomain, error: Errors, userInfo: [String: Any]? = nil) -> NSError {
        var fullUserInfo = userInfo ?? [:]
        
        fullUserInfo[NSLocalizedDescriptionKey] = error.errorDescription
        
        return NSError(domain: domain.rawValue, code: error.code, userInfo: fullUserInfo)
    }
    
    enum ErrorDomain: String {
        case databaseStore = "com.mySpend.DatabaseStore"
        case transactionsDatabase = "com.mySpend.TransactionsDatabase"
        case categoriesDatabase = "com.mySpend.CategoriesDatabase"
        
        case listenerDocumentFB = "com.mySpend.ListenersFB.listenDocument"
        case listenerCollectionFB = "com.mySpend.ListenersFB.listenCollection"
        case listenerCollectionChangesFB = "com.mySpend.ListenersFB.listenCollectionChanges"
        
        case listenerTransactions = "com.mySpend.TransactionsViewModel.listenCollectionChanges"
        case listenerCategories = "com.mySpend.CategoryViewModel.listenCollectionChanges"
    }
}
