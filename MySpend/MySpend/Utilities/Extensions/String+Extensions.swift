//
//  String+Extensions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/23.
//

import UIKit
import SwiftUICore

extension String {
    
    // MARK: CURRENCY:
    
    /**
     if there is roughly < 30 substrings to attach together, then concatenation is faster
     if there is roughly > 30 substrings to attach together, then interpolation is faster
     */
    public var addCurrencySymbol: String {
        return "\(CurrencyManager.getSelectedSymbolOrCode) \(self)" //Interpolation.
    }
    
    /**
     Converts a string representing a monetary value into a `Decimal` value based on the current locale's number format.

     This method uses a custom `NumberFormatter` to parse the input string. If the string is successfully converted into a `Decimal`, that value is returned. If the conversion fails, the method returns `0`.

     **Example:**
     ```swift
     let decimalValue = Utils.amountStringToDecimal("1,234.56")
     print(decimalValue) // Prints "1234.56"
     
     let withoutValue = Utils.amountStringToDecimal("1234")
     print(withoutValue) // Prints "1234"
     
     let invalidValue = Utils.amountStringToDecimal("invalid")
     print(invalidValue) // Prints "0"
     ```
     
     - Parameters:
        - amount: A String representing the monetary value to be converted to Decimal. The string should be formatted according to the locale's decimal separator and thousands separator
     
     - Returns: A Decimal representation of the given string, or 0 if the string cannot be converted

     - Authors: Fabian Rodriguez

     - Date: September 2024
     */
    public var convertAmountToDecimal: Decimal {
        let formatter = UtilsCurrency.getLocalFormatter
        
        if let amountCasted = formatter.number(from: self) {
            var amountDecimal = amountCasted.decimalValue
            
            // Redondear a 2 decimales
            var roundedDecimal = Decimal()
            
            NSDecimalRound(&roundedDecimal,
                           &amountDecimal,
                           CurrencyManager.fractionLength,
                           .bankers)
            
            return roundedDecimal
        } else {
            return .zero
        }
    }
    
    /**
     Rounds the input string to two decimal places if the input has more than two decimal digits. If the input has two or fewer decimal places, it returns the original input.

     This method first identifies the decimal separator based on the user's locale. It then checks if the decimal part has more than two digits. If so, it rounds the number using the `.halfUp` rounding mode.

     **Example:**
     ```swift
     let roundedValue = "1234.5678".roundIfMoreThanTwoDecimals
     print(roundedValue) // Prints "1234.57"
     
     let originalValue = "1234.56".roundIfMoreThanTwoDecimals
     print(originalValue) // Prints "1234.56"
     ```
     
     - Parameters:
        - input: A String representing the number to check and potentially round

     - Returns: An optional String? which is the original input if it has two or fewer decimals, or the rounded number if it has more than two decimals

     - Authors: Fabian Rodriguez
     
     - Date: September 2024
     */
    public var roundIfMoreThanTwoDecimals: String? {
        // 1. Crear un NumberFormatter para identificar el separador decimal
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        
        // 2. Separar la parte entera de la parte decimal
        let components = self.split(separator: formatter.decimalSeparator.first ?? ".")
        
        // 3. Si tiene una parte decimal, verificar cuántos dígitos tiene
        if components.count == 2 {
            let decimals = components[1]
            if decimals.count > 2 {
                // 4. Aplicar redondeo si tiene más de 2 dígitos decimales
                formatter.maximumFractionDigits = 2
                formatter.roundingMode = .halfUp
                if let number = formatter.number(from: self) {
                    return formatter.string(from: number)
                }
            } else {
                // 5. Si tiene exactamente 2 o menos decimales, devolver el número original
                return self
            }
        }
        
        // 6. Si no tiene decimales o ya está en el formato adecuado
        return self
    }
    
    
    // MARK: TEXT
    
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
    public var isEmptyOrWhitespace: Bool {
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
     cityName.escaped
     ```
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: Feb 2023
     */
    public var escaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
    }
    
    
    // MARK: IMAGES
    
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
    public func textToImage(size: CGFloat) -> UIImage {
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
    
    /**
     Get an Icon based on the string text SF Symbol. Example: envelope.fill

     **Example:**
     ```swift
     let icon = category.icon.getIconFromSFSymbol
     ```
     
     - Parameters:
        - iconName: SB Symbol Image name

     - Returns: SwiftUI Image

     - Date: Jul 2025
     */
    public var getIconFromSFSymbol: Image? {
        // 1. Vacía o solo espacios → nil
        guard !self.isEmptyOrWhitespace else { return nil }
        
        // 2. Valida que exista en la librería SF Symbols
        guard UIImage(systemName: self) != nil else { return nil }
        
        // 3. Sí es válido → se crea el `Image`
        return Image(systemName: self)
    }
}
