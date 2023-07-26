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
     if textField.text?.isEmptyOrWhitespace() == true {
         printContent("Is empty")
         return
     }
     ```
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: Feb 2023
     */
    func isEmptyOrWhitespace() -> Bool {
        if(self.isEmpty) {
            return true
        }
        
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    /**
     It's used to escape the URL.
     If you have a city like "New York", it's separeted by spaces (two words), the you can go and escape the String, so it can be passed concatened to the URL String.
     
     **Example:**
     ```swift
     cityName.escaped()
     ```
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: Feb 2023
     */
    func escaped() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
    }
}
