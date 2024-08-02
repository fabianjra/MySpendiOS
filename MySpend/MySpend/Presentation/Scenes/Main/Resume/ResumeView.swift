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
            .padding(.bottom)

            TextError(message: errorMessage)
            
            // MARK: RESUME
            ScrollView(showsIndicators: false) {
                ForEach(transactions) { item in
                    Text("\(item.amount?.roundedToTwoDecimalsString() ?? "0") - \(item.date ?? "")")
                        .font(.montserrat())
                        .foregroundColor(Color.textPrimaryForeground)
                }
            }
            
        }
        .onAppear {
            
            if let user = UtilsFB.getCurrentUser() {
                
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
                    transactions = await getTransactions()
                }
                
            }
        }
    }
    
    private func getTransactions() async -> [TransactionModel] {
        
        do {
            return try await SessionStore.getTransactions()
        } catch {
            errorMessage = error.localizedDescription
            return []
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
