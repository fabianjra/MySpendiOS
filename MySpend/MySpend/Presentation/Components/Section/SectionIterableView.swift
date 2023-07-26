//
//  SectionIterableView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/23.
//

import SwiftUI

//struct SectionIterableView<T: RawRepresentable & CaseIterable & Identifiable>: View where T.AllCases: RandomAccessCollection {
//
//    var iterableEnum: T.Type
//    
//    var body: some View {
//        Section {
//            ForEach(iterableEnum.allCases) { option in
//                HStack {
//                    //option.icon
//                    
//                    NavigationLink(option.rawValue, destination: option.view)
//                }
//            }
//        } header: {
//            Text("Account")
//                .foregroundColor(Color.textSecondaryForeground)
//                .font(.montserrat(size: .small))
//        }
//        .listRowBackground(Color.listRowBackground)
//        
//        
//    }
//}

//struct SectionContainer_Previews: PreviewProvider {
//    static var previews: some View {
//        SectionContainer {
//            Text("Inside list container")
//                .listRowBackground(Color.listRowBackground)
//        }
//    }
//}
