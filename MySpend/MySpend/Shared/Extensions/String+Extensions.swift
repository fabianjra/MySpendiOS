//
//  String+Extensions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/23.
//

extension String {

    /**
     Validate if a String is empty incluiding white spaces.
     
     **Example:**
     ```swift
     if textField.text?.isEmptyOrWhitespace == true {
         printContent("Is empty")
         return
     }
     ```
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: Feb 2023
     */
    public var isEmptyOrWhiteSpace: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
