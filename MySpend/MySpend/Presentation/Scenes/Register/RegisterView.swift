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
                
                TextFieldName(text: $registerVM.register.name,
                              errorMessage: $registerVM.register.errorMessage)
                .focused($focusedField, equals: .name)
                .submitLabel(.next)
                .onSubmit { focusedField = .email }
                
                
                TextFieldEmail(text: $registerVM.register.email,
                               errorMessage: $registerVM.register.errorMessage)
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .onSubmit { focusedField = .password }
                
                
                TextFieldPassword(text: $registerVM.register.password,
                                  errorMessage: $registerVM.register.errorMessage,
                                  iconLeading: Image.lockFill)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .password)
                .submitLabel(.next)
                .onSubmit { focusedField = .passwordConfirm }
                
                
                TextFieldPassword(placeHolder: "Confirm password",
                                  text: $registerVM.register.passwordConfirm,
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
            }
        }
        .disabled(registerVM.register.isLoading)
    }
}

#Preview {
    RegisterView()
}
