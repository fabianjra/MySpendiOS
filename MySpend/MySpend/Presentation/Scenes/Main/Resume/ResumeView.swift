//
//  ResumeView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 1/8/23.
//

import SwiftUI
import Firebase

struct ResumeView: View {
    
    @ObservedObject var resumeVM: ResumeViewModel
    
//    init(model: Resume = Resume()) {
//        /*
//         * SwiftUI ensures that the following initialization uses the
//         * closure only once during the lifetime of the view, so
//         * later changes to the view's name input have no effect.
//         */
//        _resumeVM = StateObject(wrappedValue: ResumeViewModel(model: model))
//    }
    
    var body: some View {
        ContentContainer {
            
            // MARK: HEADER
            HStack {
                VStack(alignment: .leading) {
                    Text("Hello \(resumeVM.model.userName) \(ConstantEmojis.greeting)")
                        .font(.montserrat(.semibold, size: .big))
                        .lineLimit(ConstantViews.messageMaxLines)
                    
                    Text("Welcome back")
                        .font(.montserrat(.light, size: .small))
                }
                .foregroundColor(Color.textPrimaryForeground)
                Spacer()
            }
            .padding(.bottom)
            
            
            // MARK: CONTENT
            VStack {
                
                Button("History") {
                    
                }
                .buttonStyle(ButtonHorizontalStyle(subTitle: "Go to history",
                                                   iconLeading: Image.stackFill))
            }

            TextError(message: resumeVM.model.errorMessage)
            
            // MARK: RESUME
            VStack {
                ScrollView(showsIndicators: false) {
                    ForEach(resumeVM.model.transactions) { item in
                        HStack {
                            TextPlain(message: "\(item.category?.description ?? "")")
                            
                            Spacer()
                            
                            TextPlain(message: "$ \(item.amount?.roundedToTwoDecimalsString() ?? "$ 0.00")")
                        }
                        .padding(.vertical, ConstantViews.textResumeSpacing)
                        .padding(.horizontal)
                    }
                }
                
                DividerView()
                    .background(.blue)
                
                HStack {
                    TextPlain(message: "Balance", 
                              size: .big)
                    Spacer()
                    
                    TextPlain(message: "$ \(resumeVM.model.totalBalance.roundedToTwoDecimalsString())",
                              size: .big)
                }
            }
            .padding(.bottom, ConstantViews.paddingBottomResumeview)
 
        }
        .onAppear {
            
            Task {
                await resumeVM.onAppear()
            }
        }
    }
}

#Preview("With Content") {
    VStack {
        let _ = CategoryModel(icon: "envelope.fill", description: "Gasolina")
        let _ = CategoryModel(icon: "lock.fill", description: "Comida")
        let _ = CategoryModel(icon: "person.fill", description: "Turismo")
        
        let transaction1 = TransactionModel(amount: 56000,
                                            date: "25/05/1990",
                                            category: "01",
                                            detail: "Nota",
                                            type: .expense)
        let transaction2 = TransactionModel(amount: 3000,
                                            date: "25/05/2024",
                                            category: "02",
                                            detail: "Nota",
                                            type: .expense)
        let transaction3 = TransactionModel(amount: 100,
                                            date: "01/12/2003",
                                            category: "03",
                                            detail: "Nota",
                                            type: .expense)
        let transaction4 = TransactionModel(amount: 270000,
                                            date: "01/05/2023",
                                            category: "04",
                                            detail: "Nota",
                                            type: .expense)
        
        let transactionArray = [transaction1, transaction2, transaction3, transaction4]
        
        let resume = Resume(userName: "vista previa",
                            transactions: transactionArray,
                            totalBalance: 0.0,
                            errorMessage: "")
        
        let resumeVM = ResumeViewModel(model: resume)
        
        ResumeView(resumeVM: resumeVM)
            .environment(\.locale, .init(identifier: "es"))
    }
}

#Preview("No content") {
    ResumeView(resumeVM: ResumeViewModel())
        .environment(\.locale, .init(identifier: "en"))
}
