//
//  ChangeNameView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/23.
//

import SwiftUI

struct ChangeNameView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var userName: String = ""
    
    @State private var newUserName: String = ""
    @State private var isNewUserNameError: Bool = false

    
    @State private var errorMessage: String = ""
    @State private var canRegister: Bool = false
    
    var body: some View {
        
        FormContainer {
            
            //MARK: HEADER
            HStack {
                ButtonNavigationBack { dismiss() }
                    .padding(.leading)
                
                Spacer()
                
                TextTitleForm(title: "Change name",
                              titleWeight: .regular,
                              titleSize: .bigXL,
                              subTitle: "Type your new name",
                              subTitleWeight: .regular)
                    
                Spacer()
                
                ButtonNavigationBack {}
                    .hidden()
                    .padding(.trailing)
            }
            .padding(.bottom)

            //MARK: REGISTER
            VStack(spacing: Views.formSpacing) {
                
                TextFieldName(text: $userName,
                              isError: .constant(false),
                              errorMessage: .constant(""))
                .submitLabel(.done)
            }
            
        }
    }
}

struct ChangeNameView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeNameView()
    }
}
