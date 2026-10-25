//
//  Double+Extensions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 1/8/24.
//

import Foundation

extension Double {
    
    /**
     Redondea el número a la cantidad especificada de decimales.
     
     - Parameters:
        - places: La cantidad de decimales a redondear.
     
     - Returns: El valor redondeado.
     
     - Authors: Fabian Rodriguez
     
     - Date: December 2024
     */
    private func rounded(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    /**
     Redondea el número a la cantidad especificada de decimales y lo devuelve como una cadena.
     
     - Parameters:
        - places: La cantidad de decimales a redondear.
     
     - Returns: El valor redondeado en formato de cadena.
     
     - Authors: Fabian Rodriguez
     
     - Date: December 2024
     */
    public func roundedString(to places: Int) -> String {
        return String(format: "%.\(places)f", self.rounded(to: places))
    }
    
    /**
     Redondea el número a dos decimales.
     
     - Returns: El valor redondeado a dos decimales.
     
     - Authors: Fabian Rodriguez
     
     - Date: December 2024
     */
    private var roundedToTwoDecimals: Double {
        return rounded(to: 2)
    }
    
    /**
     Redondea el número a dos decimales y lo devuelve como una cadena.
     
     - Returns: El valor redondeado a dos decimales en formato de cadena.
     
     - Authors: Fabian Rodriguez
     
     - Date: December 2024
     */
    public var roundedToTwoDecimalsString: String {
        return String(format: "%.2f", self.roundedToTwoDecimals)
    }
}
