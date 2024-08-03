//
//  ResumeView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 1/8/23.
//

import SwiftUI
import Firebase

struct ResumeView: View {
    
    @State var userName: String = ""
    @State var transactions: [TransactionModel] = []
    @State var totalBalance: Double = 0
    
    @State private var errorMessage: String = ""
    
    var body: some View {
        ContentContainer {
            
            // MARK: HEADER
            HStack {
                VStack(alignment: .leading) {
                    Text("Hello \(userName) \(ConstantEmojis.greeting)")
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

            TextError(message: errorMessage)
            
            // MARK: RESUME
            VStack {
                ScrollView(showsIndicators: false) {
                    ForEach(transactions) { item in
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
                    TextPlain(message: "Balance", size: .big)
                    Spacer()
                    TextPlain(message: "$ \(totalBalance.roundedToTwoDecimalsString())", size: .big)
                }
            }
            .padding(.bottom, ConstantViews.paddingBottomResumeview)
 
        }
        .onAppear {
            
            if let user = UtilsStore.getCurrentUser() {
                
                // The user's ID, unique to the Firebase project.
                // Do NOT use this value to authenticate with your backend server,
                // if you have one. Use getTokenWithCompletion:completion: instead.
                
                let _: String = user.providerID
                let _: String = user.uid
                let displayName: String? = user.displayName
                let _: URL? = user.photoURL
                let _: String? = user.email
                
                var multiFactorString = "MultiFactor: "
                for info in user.multiFactor.enrolledFactors {
                  multiFactorString += info.displayName ?? "[DispayName]"
                  multiFactorString += " "
                }
                
                userName = displayName ?? ""
                
                Task {
                     await getTransactions()
                }
                
            }
        }
    }
    
    private func getTransactions() async {
        
        do {
            //TODO: Descomentar para pruebas:
            //transactions = try await DatabaseStore.getTransactions()
            
            for item in transactions {
                totalBalance += item.amount ?? 0
            }
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct ResumeView_Previews: PreviewProvider {
    static var previews: some View {
        
        let category1 = CategoryModel(description: "Gasolina")
        let category2 = CategoryModel(description: "Comida")
        let category3 = CategoryModel(description: "Turismo")
        
        let transaction1 = TransactionModel(amount: 56000,
                                           date: "25/05/1990",
                                           category: category1,
                                           detail: "Nota",
                                           type: .expense)
        let transaction2 = TransactionModel(amount: 3000,
                                           date: "25/05/2024",
                                           category: category2,
                                           detail: "Nota",
                                           type: .expense)
        let transaction3 = TransactionModel(amount: 100,
                                           date: "01/12/2003",
                                           category: category1,
                                           detail: "Nota",
                                           type: .expense)
        let transaction4 = TransactionModel(amount: 270000,
                                           date: "01/05/2023",
                                           category: category3,
                                           detail: "Nota",
                                           type: .expense)
        
        let transactionArray = [transaction1, transaction2, transaction3, transaction4]
        
        ResumeView(userName: "Vista previa",
                   transactions: transactionArray)
    }
}
