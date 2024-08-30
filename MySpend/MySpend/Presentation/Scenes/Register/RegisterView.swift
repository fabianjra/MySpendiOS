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
        FormContainer {
            
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
                        let canSubmit = await registerVM.validateRegister()
                        
                        if canSubmit {
                            Router.shared.path.append(Router.Destination.main)
                        }
                    }
                }
                
                
                Button("Register") {
                    Task {
                        focusedField = .none
                        let canSubmit = await registerVM.validateRegister()
                        
                        if canSubmit {
                            Router.shared.path.append(Router.Destination.main)
                        }
                    }
                }
                .buttonStyle(ButtonPrimaryStyle(isLoading: $registerVM.register.isLoading))
                .padding(.bottom)
                
                
                TextError(message: registerVM.register.errorMessage)
            }
        }
        .disabled(registerVM.register.isLoading)
    }
}

#Preview {
    RegisterView()
}
