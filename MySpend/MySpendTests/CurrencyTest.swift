//
//  CurrencyTest.swift
//  MySpendTests
//
//  Created by Fabian Rodriguez on 19/9/24.
//

import Testing
@testable import MySpend
import Foundation

struct CurrencyTest {
    
    let formatter = NumberFormatter()
    
    init() {
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
    }

    // MARK: REAL TESTS STARS HERE:
    
    @Test("Verifica que el monto de string se covierta corretamente a decimal, conservando maximo 2 decimales redondeando en caso de ser mas de 2 decimales")
    func test_convert_string_amout_to_decimal() {
        
        #expect(("400\(formatter.decimalSeparator ?? ".")56".convertAmountToDecimal) == 400.56)
        
        #expect(("400\(formatter.decimalSeparator ?? ".")00".convertAmountToDecimal) == 400)
        
        #expect(("0\(formatter.decimalSeparator ?? ".")00".convertAmountToDecimal) == 0)
        
        #expect(("0".convertAmountToDecimal) == 0)
        
        #expect(("500".convertAmountToDecimal) == 500)
        
        #expect(("7806.8995".convertAmountToDecimal) == 7806.90) //Redondea al siguiente valor
        
        #expect(("7806.8915".convertAmountToDecimal).description == "7806.89") //Redondea sin subir el valor.
        
        #expect(("text".convertAmountToDecimal) == 0)
        
        #expect(("".convertAmountToDecimal) == 0)
    }
}
