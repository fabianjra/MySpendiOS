//
//  RegisterView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/23.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject var registerVM = RegisterViewModel()
    @FocusState private var focusedField: Register.Field?
    
    var body: some View {
        FormScrollContainer {
            
            // MARK: HEADER
            HeaderNavigator(subTitle: "Register new user")
                .padding(.bottom)
            
            
            // MARK: REGISTER
            VStack(spacing: ConstantViews.formSpacing) {
                
                TextFieldName(text: $registerVM.register.userName,
                              isError: $registerVM.register.isUserNameError,
                              errorMessage: $registerVM.register.errorMessage)
                .focused($focusedField, equals: .name)
                .submitLabel(.next)
                .onSubmit { focusedField = .email }
                
                
                TextFieldEmail(text: $registerVM.register.userEmail,
                               isError: $registerVM.register.isUserEmailError,
                               errorMessage: $registerVM.register.errorMessage)
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .onSubmit { focusedField = .password }
                
                
                TextFieldPassword(text: $registerVM.register.userPassword,
                                  isError: $registerVM.register.isUserPasswordError,
                                  errorMessage: $registerVM.register.errorMessage,
                                  iconLeading: Image.lockFill)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .password)
                .submitLabel(.next)
                .onSubmit { focusedField = .passwordConfirm }
                
                
                TextFieldPassword(placeHolder: "Confirm password",
                                  text: $registerVM.register.userPasswordConfirm,
                                  isError: $registerVM.register.isUserPasswordConfirmError,
                                  errorMessage: $registerVM.register.errorMessage,
                                  iconLeading: Image.checkmark)
                .padding(.bottom)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .passwordConfirm)
                .submitLabel(.done)
                .onSubmit {
                    Task {
                        focusedField = .none
                        await registerVM.validateRegister()
                    }
                }
                
                
                Button("Register") {
                    Task {
                        focusedField = .none
                        await registerVM.validateRegister()
                    }
                }
                .buttonStyle(ButtonPrimaryStyle(isLoading: $registerVM.register.isLoading))
                .padding(.bottom)
                .navigationDestination(isPresented: $registerVM.register.canSubmit) {
                    MainView(selectedTab: .resume)
                        .toolbar(.hidden)
                }
                
                
                TextError(message: registerVM.register.errorMessage)
                
                //TODO: Resolver para mostrar mensajes de error:
                TextError(message: registerVM.register.errorUpdateName)
                TextError(message: registerVM.register.errorSendEmail)
            }
        }
        .disabled(registerVM.register.isLoading)
    }
}

#Preview {
    RegisterView()
}
