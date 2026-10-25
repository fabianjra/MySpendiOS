//
//  Int64+Extensions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 15/7/25.
//

import Foundation

extension Int64 {
    
    /**
     Safely converts the `Int64` to `Int`.
     
     * Returns the exact value when it fits in the platform `Int`.
     * Returns **0** when the value is outside `Int`’s bounds (prevents overflow / underflow).
     
     ```swift
     let ok:   Int64 =  9_000
     let big:  Int64 =  Int64.max      // too large for 32‑bit Int
     let neg:  Int64 = -9_000
     
     ok .asIntSafe   // → 9000
     big.asIntSafe   // → 0
     neg.asIntSafe   // → -9000
     ```
     */
    var toInt: Int {
        Int(exactly: self) ?? .zero // nil when out‑of‑range → 0
    }
}
