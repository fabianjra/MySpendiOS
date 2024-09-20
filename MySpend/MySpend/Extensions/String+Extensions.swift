//
//  String+Extensions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/23.
//

import UIKit

extension String {
    
    public func addCurrencySymbol() -> String {
        // if there is roughly < 30 substrings to attach together, then concatenation is faster
        // if there is roughly > 30 substrings to attach together, then interpolation is faster
        return "\(CurrencySymbol.shared.description.rawValue) \(self)"
    }
    
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
    
    /**
     Convert a given text to UIImage (UIKit image).
     It's necessary that the SwiftUI Image control, receive as parameter "uiImage".
     
     **Example:**
     ```swift
     public var body: some View {
        let imageFromText = "👋".textToImage(size: 50)
        Image(uiImage: imageFromText)
     }
     ```
     
     - Parameters:
        - size:The size the image will have.
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: Aug 2023
     */
    func textToImage(size: CGFloat) -> UIImage {
        let nsString = (self as NSString)
        let font = UIFont.systemFont(ofSize: size)
        let stringAttributes = [NSAttributedString.Key.font: font]
        let imageSize = nsString.size(withAttributes: stringAttributes)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, CGFloat.zero)
        UIColor.clear.set()
        UIRectFill(CGRect(origin: CGPoint(), size: imageSize))
        nsString.draw(at: CGPoint.zero, withAttributes: stringAttributes)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
}
