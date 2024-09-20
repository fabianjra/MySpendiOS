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
        
        #expect(UtilsCurrency.amountStringToDecimal("400\(formatter.decimalSeparator ?? ".")56") == 400.56)
        
        #expect(UtilsCurrency.amountStringToDecimal("400\(formatter.decimalSeparator ?? ".")00") == 400)
        
        #expect(UtilsCurrency.amountStringToDecimal("0\(formatter.decimalSeparator ?? ".")00") == 0)
        
        #expect(UtilsCurrency.amountStringToDecimal("0") == 0)
        
        #expect(UtilsCurrency.amountStringToDecimal("500") == 500)
        
        #expect(UtilsCurrency.amountStringToDecimal("7806.8995") == 7806.90) //Redondea al siguiente valor
        
        #expect(UtilsCurrency.amountStringToDecimal("7806.8915").description == "7806.89") //Redondea sin subir el valor.
        
        #expect(UtilsCurrency.amountStringToDecimal("text") == 0)
        
        #expect(UtilsCurrency.amountStringToDecimal("") == 0)
    }
}
