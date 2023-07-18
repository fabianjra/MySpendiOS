//
//  RegisterView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/23.
//

import SwiftUI

struct RegisterView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var userName: String = ""
    @State private var isUserNameError: Bool = false
    
    @State private var userEmail: String = ""
    @State private var isUserEmailError: Bool = false
    
    @State private var userPassword: String = ""
    @State private var isUserPasswordError: Bool = false
    
    @State private var userPasswordConfirm: String = ""
    @State private var isUserPasswordConfirmError: Bool = false
    
    @State private var errorMessage: String = ""
    @State private var canRegister: Bool = false
    
    var body: some View {
        
        ZStack(alignment: .top) {

            VStack {
                
                //MARK: HEADER
                HStack {
                    
                    ButtonNavigationBack { dismiss() }
                        .padding(.leading)
                    
                    Spacer()
                    
                    TextTitleForm(subTitle: "Register new user")
                        .padding(.bottom)
                    
                    Spacer()
                    
                    ButtonNavigationBack {}
                        .hidden()
                        .padding(.trailing)
                }
                
                //MARK: REGISTER
                VStack(spacing: Views.formSpacing) {

                    TextFieldName(text: $userName,
                                  isError: $isUserNameError,
                                  errorMessage: $errorMessage)
                    .submitLabel(.done)
                    
                    
                    TextFieldEmail(text: $userEmail,
                                   isError: $isUserEmailError,
                                   errorMessage: $errorMessage)
                    
                    TextFieldPassword(text: $userPassword,
                                      isError: $isUserPasswordError,
                                      errorMessage: $errorMessage,
                                      iconLeading: Image.lockFill)
                    
                    TextFieldPassword(text: $userPasswordConfirm,
                                      isError: $isUserPasswordConfirmError,
                                      errorMessage: $errorMessage,
                                      iconLeading: Image.checkmark)
                    
                    Button("Register") {
                        
                        print("User: \(userName)")
                        print("Email: \(userEmail)")
                        print("Password: \(userPassword)")
                        print("Password confirm: \(userPasswordConfirm)")
                        
                        if userName.isEmpty || userEmail.isEmpty ||
                            userPassword.isEmpty || userPasswordConfirm.isEmpty {
                            canRegister = false
                            errorMessage = "Fill the text fields required"
                        } else {
                            canRegister = true
                        }

                        //If Textfields are empty, bool error will be true.
                        isUserNameError = userName.isEmpty
                        isUserEmailError = userEmail.isEmpty
                        isUserPasswordError = userPassword.isEmpty
                        isUserPasswordConfirmError = userPasswordConfirm.isEmpty
                    }
                    .buttonStyle(ButtonPrimaryStyle())
                    .padding(.bottom)
                    .navigationDestination(isPresented: $canRegister) {
                        TabViewCustom(selectedTab: .resume)
                            .toolbar(.hidden, for: .navigationBar)
                    }
                    
                    
                    Text(errorMessage)
                        .modifier(Show(isVisible: !errorMessage.isEmpty))
                        .foregroundColor(Color.textErrorForeground)
                        .font(.custom(FontFamily.semibold.rawValue, size: FontSizes.body))
                        .multilineTextAlignment(.center)
                        .lineLimit(Views.messageMaxLines)
                    
                }
                .padding(.bottom)
                
                
                //MARK: DIVISION
                DividerView()
                    .padding(.bottom)
                
                
                //MARK: GO BACK
//                VStack {
//
//                    Button("Go back") {
//                        dismiss()
//                    }
//                    .buttonStyle(ButtonPrimaryStyle(color: Color.secondaryGradiant))
//                    .padding(.bottom)
//                    .padding(.horizontal, Views.paddingSmallButton)
//                }
            }
            .modifier(FormStyleSign())
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
