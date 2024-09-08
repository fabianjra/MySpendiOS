//
//  ResumeView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 1/8/23.
//

import SwiftUI

struct ResumeView: View {
    
    @ObservedObject var viewModel: ResumeViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
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
                    Text("Hello \(viewModel.model.userName) \(ConstantEmojis.greeting)")
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
                    Router.shared.path.append(Router.Destination.history)
                }
                .buttonStyle(ButtonHorizontalStyle(subTitle: "Go to history",
                                                   iconLeading: Image.stackFill))
            }
            
            
            TextError(message: viewModel.errorMessage)
            
            // MARK: RESUME
            VStack {
                ScrollView(showsIndicators: false) {
                    ForEach(viewModel.model.transactions) { item in
                        HStack {
                            TextPlain(message: item.categoryId.description)
                            
                            Spacer()
                            
                            TextPlain(message: "$ \(item.amount.roundedToTwoDecimalsString())")
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
                    
                    TextPlain(message: "$ \(viewModel.model.totalBalance.roundedToTwoDecimalsString())",
                              size: .big)
                }
            }
            .padding(.bottom, ConstantViews.paddingBottomResumeview)
 
        }
        .onAppear {
            print("Router count RESUME: \(Router.shared.path.count)")
            Task {
                await viewModel.onAppear(authViewModel)
            }
        }
        .onDisappear {
            //TODO: Verificar que sea necesario limpiar el viewModel, ya que la vista desaparece.
            if authViewModel.currentUser == nil {
                viewModel.model.transactions = []
                viewModel.model.totalBalance = 0
                viewModel.model.userName = ""
            }
        }
    }
}

#Preview("With Content") {
    VStack {
        let transaction1 = TransactionModel(amount: 56000,
                                            date: "25/05/1990",
                                            categoryId: "01",
                                            detail: "Nota",
                                            type: .expense)
        let transaction2 = TransactionModel(amount: 3000,
                                            date: "25/05/2024",
                                            categoryId: "02",
                                            detail: "Nota",
                                            type: .expense)
        let transaction3 = TransactionModel(amount: 100,
                                            date: "01/12/2003",
                                            categoryId: "03",
                                            detail: "Nota",
                                            type: .expense)
        let transaction4 = TransactionModel(amount: 270000,
                                            date: "01/05/2023",
                                            categoryId: "04",
                                            detail: "Nota",
                                            type: .expense)
        
        let transactionArray = [transaction1, transaction2, transaction3, transaction4]
        
        let resume = Resume(userName: "vista previa",
                            transactions: transactionArray,
                            totalBalance: 0.0)
        
        let resumeVM = ResumeViewModel(model: resume)
        
        ResumeView(viewModel: resumeVM)
            .environment(\.locale, .init(identifier: "es"))
            .environmentObject(AuthViewModel())
    }
}

#Preview("No content") {
    ResumeView(viewModel: ResumeViewModel())
        .environment(\.locale, .init(identifier: "en"))
        .environmentObject(AuthViewModel())
}
