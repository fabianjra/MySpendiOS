//
//  CaseIterable+Extensions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/9/24.
//

extension CaseIterable where Self: Equatable {
    func next() -> Self? {
        guard let allCases = Self.allCases as? [Self],
              let currentIndex = allCases.firstIndex(of: self),
              currentIndex < allCases.count - 1 else {
            return nil
        }
        return allCases[currentIndex + 1]
    }
    
    func previous() -> Self? {
        guard let allCases = Self.allCases as? [Self],
              let currentIndex = allCases.firstIndex(of: self),
              currentIndex > 0 else {
            return nil
        }
        return allCases[currentIndex - 1]
    }
}