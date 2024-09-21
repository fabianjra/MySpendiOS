//
//  ResumeView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 1/8/23.
//

import SwiftUI

struct ResumeView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var viewModel: ResumeViewModel
    
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
            
            
            // MARK: HISTORY BUTTON
            VStack {
                Button("History") {
                    //Router.shared.path.append(Router.Destination.history)
                    viewModel.navigateToHistory = true

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
                            TextPlain(message: item.categoryId.description,
                                      lineLimit: ConstantViews.transactionsMaxLines)
                            
                            Spacer()
                            
                            TextPlain(message: item.amount.convertAmountDecimalToString().addCurrencySymbol(),
                                      lineLimit: ConstantViews.transactionsMaxLines)
                        }
                        .padding(.vertical, ConstantViews.textResumeSpacing)
                        .padding(.horizontal)
                    }
                }
                
                DividerView()
                    .background(.blue)
                
                // MARK: TOTAL BALANCE
                HStack {
                    TextPlain(message: "Balance", 
                              size: .big)
                    Spacer()
                    
                    TextPlain(message: viewModel.model.totalBalanceFormatted,
                              size: .big)
                }
            }
            .padding(.bottom, ConstantViews.paddingBottomResumeview)
            
            //Tiene un efecto no deseado al transicionar entre tab y tab.
            //TODO: Revisar si con listener se comporta diferente.
            //.redacted(reason: viewModel.isLoading ? .placeholder : [])
 
        }
        .onAppear {
            print("Router count RESUME: \(Router.shared.path.count)")
            Task {
                await viewModel.onAppear(authViewModel)
            }
        }
        /*
         Navigation sin el Stack provoca la siguiente alerta:
         
         Do not put a navigation destination modifier inside a "lazy” container, like `List` or `LazyVStack`. These containers create child views only when needed to render on screen. Add the navigation destination modifier outside these containers so that the navigation stack can always see the destination. There's a misplaced `navigationDestination(isPresented:destination:)` modifier presenting `ModifiedContent<HistoryView, ToolbarAppearanceModifier>`. It will be ignored in a future release.
         
         No se esta utilizando List o LazyVStack, por lo que no genera problemas, pero la alerta se sigue mostrando.
         */
        .navigationDestination(isPresented: $viewModel.navigateToHistory) {
            let historyViewModel = HistoryViewModel(transactions: viewModel.model.transactions)
            
            HistoryView(viewModel: historyViewModel)
                .toolbar(.hidden, for: .navigationBar)
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
        let transaction2 = TransactionModel(amount: 3000.00,
                                            date: "25/05/2024",
                                            categoryId: "02",
                                            detail: "Nota",
                                            type: .expense)
        let transaction3 = TransactionModel(amount: 100.12,
                                            date: "01/12/2003",
                                            categoryId: "03",
                                            detail: "Nota",
                                            type: .expense)
        let transaction4 = TransactionModel(amount: 270000,
                                            date: "01/05/2023",
                                            categoryId: "04",
                                            detail: "Nota",
                                            type: .expense)
        
        let transaction5 = TransactionModel(amount: 270046.7802,
                                            date: "01/05/2023",
                                            categoryId: "05",
                                            detail: "Nota",
                                            type: .expense)
        
        let transactionArray = [transaction1, transaction2, transaction3, transaction4, transaction5]
        
        let resume = Resume(userName: "vista previa",
                            transactions: transactionArray,
                            totalBalance: .zero)
        
        let resumeVM = ResumeViewModel(model: resume)
        
        ResumeView(viewModel: resumeVM)
            .environment(\.locale, .init(identifier: "es"))
            .environmentObject(AuthViewModel())
    }
}

#Preview("Saturated content") {
    VStack {
        let transaction1 = TransactionModel(amount: 56000234234.23434,
                                            date: "25/05/1990",
                                            categoryId: "alsjdfasjflkasj dflkasjdlkfjaslkfjalsk asd f",
                                            detail: "Nota",
                                            type: .expense)
        let transaction2 = TransactionModel(amount: 3002342340.00,
                                            date: "25/05/2024",
                                            categoryId: "02",
                                            detail: "Nota",
                                            type: .expense)
        let transaction3 = TransactionModel(amount: 100.12,
                                            date: "01/12/2003",
                                            categoryId: "asdfasdfasdfasdfk jkfj askjf aksjf ksjf kasjf kasf jk",
                                            detail: "Nota",
                                            type: .expense)
        let transaction4 = TransactionModel(amount: 27677776763244437674.23423434,
                                            date: "01/05/2023",
                                            categoryId: "asdf asfa",
                                            detail: "Nota",
                                            type: .expense)
        
        let transaction5 = TransactionModel(amount: 270046.7802,
                                            date: "01/05/2023",
                                            categoryId: "05",
                                            detail: "Nota",
                                            type: .expense)
        
        let transactionArray = [transaction1, transaction2, transaction3, transaction4, transaction5]
        
        let resume = Resume(userName: "vista previa",
                            transactions: transactionArray,
                            totalBalance: .zero)
        
        let resumeVM = ResumeViewModel(model: resume)
        
        ResumeView(viewModel: resumeVM)
            .environment(\.locale, .init(identifier: "en"))
            .environmentObject(AuthViewModel())
    }
}

#Preview("No content") {
    ResumeView(viewModel: ResumeViewModel())
        .environment(\.locale, .init(identifier: "en"))
        .environmentObject(AuthViewModel())
}
