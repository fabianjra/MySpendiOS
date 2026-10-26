//
//  Logger.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/7/23.
//

import Foundation
//import FirebaseCrashlytics
//import FirebaseAnalytics

enum ErrorType {
    case none
    case CoreData
}

struct Logger {

    /**
     Sends the caught `Error` to Firebase Crashlytics and attaches the source-code context as custom keys.
     
     El helper usa @inline(__always) para que el compilador inserte los literales #file, #function, #line del sitio donde llames CatchException,
     no de donde se define recordToCrashlytics.
     
     - Parameters:
        -  error:     The `Error` object that you just caught.
        - file:      Compiler literal that captures the file name (`#file`).
        - function:  Compiler literal that captures the function name (`#function`).
        - line:      Compiler literal that captures the line number (`#line`).
     */
    @inline(__always)
    static func recordToCrashlytics(_ error: Error,
                                    file: String = #file,
                                    function: String = #function,
                                    line: Int = #line) {

        //let crashlytics = Crashlytics.crashlytics()

        // Log a breadcrumb for quick filtering in the Crashlytics console
        //let fileName = file.components(separatedBy: "/").last ?? file
        //crashlytics.log("CatchException – \(fileName):\(line) – \(function)")

        // Attach source context as custom keys (visible in the stack-trace panel)
        //crashlytics.setCustomValue((file as NSString).lastPathComponent, forKey: "file")
        //crashlytics.setCustomValue(function, forKey: "function")
        //crashlytics.setCustomValue(line, forKey: "line")

        // Record the error; Crashlytics will group identical exceptions
        //crashlytics.record(error: error)
    }

    
    /**
     Shows a Catch error message on console.
     
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
            Logger.exception(error)
     }
     ```
     
     - Parameters:
        - error: The catch error message from the try.
        - type: Error type. if null, only write single line.
     
     - Returns: Void
     - Warning: N/A
     - Throws: N/A
     - Authors: Fabian Rodriguez
     - Version: 1.1
     - Date: June 2025
     */
    static func exception(_ error: Error,
                          type: ErrorType = .none,
                          file: String = #file,
                          function: String = #function,
                          line: Int = #line,
                          id: String = UUID().uuidString) {
        
        let logId = id
        print("********** START EXCEPTION LOG: \(logId)")
        print("Handled catch in: \(file.components(separatedBy: "/").last ?? file), function: \(function), line: \(line), description: \(error.localizedDescription)")
        
        if UtilsUI.useAnalytics {
            recordToCrashlytics(error, file: file, function: function, line: line)
        }
        
        switch type {
        case .none:
            break
            
        case .CoreData:
            CoreDataCatchException(error)
        }
        
        print("********** END EXCEPTION LOG.")
    }
    
    private static func CoreDataCatchException(_ error: Error) {
        
        if let nsError = error as NSError? {
            
            // NSDetailedErrors
            if let coreDataInfo = nsError.userInfo["NSDetailedErrors"] as? NSArray {
                for detail in coreDataInfo {
                    if let error = detail as? NSError {
                        print(" • \(error.localizedDescription)")
                    }
                }
            } else {
                for (key, value) in nsError.userInfo {
                    print("\(key): \(value)")
                }
            }
            
            // Otros:
            /*
             NSLocalizedDescriptionKey
             Descripción corta del error (siempre deberías intentar mostrar esta al usuario).
             
             NSLocalizedFailureReasonErrorKey
             Motivo específico del error, si existe.
             
             NSLocalizedRecoverySuggestionErrorKey
             Sugerencia para recuperar del error.
             
             NSDetailedErrors
             Solo la usa Core Data para validaciones múltiples.
             
             NSValidationErrorKey, NSValidationErrorObject
             Solo para validación en Core Data.
             */
        }
    }

    
    /**
     Shows a message on console.
     
     **Notes:**
     - Writes a simple string message on console.
     
     **Example:**
     ```swift
        Logger.WriteMessage("This is a string message.")
     ```
     
     - Parameters:
        - message:String message to add to the print.
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: February 2023
     */
    static func custom(_ obj: Any,
                       file: String = #file,
                       function: String = #function,
                       line: Int = #line,
                       id: String = UUID().uuidString) {
        
        let fileName = file.components(separatedBy: "/").last ?? file
        
        //#if DEBUG
        let logId = id
        print("********** START CUSTOM MESSSAG LOG: \(logId)")
        let message = "-Print from: \(fileName), function: \(function), line: \(line) \n-Description: \(obj)"
        print(message)
        print("********** END CUSTOM MESSSAG LOG.")
        
        //#else
        
        if UtilsUI.useAnalytics {
            // Para el titulo: Máximo 40 caracteres, minúsculas, sin espacios.
//            Analytics.logEvent("ios_custom_log", parameters: [
//                "file": fileName,
//                "function": function,
//                "line": line,
//                "message": String(describing: obj)
//            ])
        }
        //#endif
    }
}
