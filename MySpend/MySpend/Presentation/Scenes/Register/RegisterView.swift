//
//  RegisterView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/23.
//

import SwiftUI
import Firebase

private enum Field: Hashable {
    case name
    case email
    case password
    case passwordConfirm
}

struct RegisterView: View {
    
    //TODO: PASAR A VIEWMODEL.
    @State private var userName: String = ""
    @State private var isUserNameError: Bool = false
    
    @State private var userEmail: String = ""
    @State private var isUserEmailError: Bool = false
    
    @State private var userPassword: String = ""
    @State private var isUserPasswordError: Bool = false
    
    @State private var userPasswordConfirm: String = ""
    @State private var isUserPasswordConfirmError: Bool = false
    
    @State private var errorMessage: String = ""
    @State private var canSubmit: Bool = false
    
    @State private var errorUpdateName: String = ""
    @State private var errorSendEmail: String = ""
    
    @State private var isLoading: Bool = false
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        FormScrollContainer {
            
            // MARK: HEADER
            HeaderNavigator(subTitle: "Register new user")
                .padding(.bottom)
            
            
            // MARK: REGISTER
            VStack(spacing: ConstantViews.formSpacing) {
                
                TextFieldName(text: $userName,
                              isError: $isUserNameError,
                              errorMessage: $errorMessage)
                .focused($focusedField, equals: .name)
                .submitLabel(.next)
                .onSubmit { focusedField = .email }
                
                
                TextFieldEmail(text: $userEmail,
                               isError: $isUserEmailError,
                               errorMessage: $errorMessage)
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .onSubmit { focusedField = .password }
                
                
                TextFieldPassword(text: $userPassword,
                                  isError: $isUserPasswordError,
                                  errorMessage: $errorMessage,
                                  iconLeading: Image.lockFill)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .password)
                .submitLabel(.next)
                .onSubmit { focusedField = .passwordConfirm }
                
                
                TextFieldPassword(placeHolder: "Confirm password",
                                  text: $userPasswordConfirm,
                                  isError: $isUserPasswordConfirmError,
                                  errorMessage: $errorMessage,
                                  iconLeading: Image.checkmark)
                .padding(.bottom)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .passwordConfirm)
                .submitLabel(.done)
                .onSubmit {
                    Task {
                        await validateRegister()
                    }
                }
                
                
                Button("Register") {
                    Task {
                        await validateRegister()
                    }
                }
                .buttonStyle(ButtonPrimaryStyle(isLoading: $isLoading))
                .padding(.bottom)
                .navigationDestination(isPresented: $canSubmit) {
                    MainView(selectedTab: .resume)
                        .toolbar(.hidden)
                }
                
                
                TextError(message: errorMessage)
                
                TextError(message: errorUpdateName)
                TextError(message: errorSendEmail)
            }
        }
        .disabled(isLoading)
    }
    
    private func validateRegister() async {
        
        focusedField = .none
        
        isUserNameError = userName.isEmptyOrWhitespace()
        isUserEmailError = userEmail.isEmptyOrWhitespace()
        isUserPasswordError = userPassword.isEmptyOrWhitespace()
        isUserPasswordConfirmError = userPasswordConfirm.isEmptyOrWhitespace()
        
        if isUserNameError || isUserEmailError ||
            isUserPasswordError || isUserPasswordConfirmError {
            errorMessage = ConstantMessages.emptySpaces.localizedDescription
            return
        }
        
        if userPassword.count < 6 || userPasswordConfirm.count < 6 {
            errorMessage = ConstantMessages.passwordIsShort.localizedDescription
            return
        }
        
        if userPassword != userPasswordConfirm {
            errorMessage = ConstantMessages.creationPasswordIsDifferent.localizedDescription
            return
        }
        
        isLoading = true
        
        do {
            defer {
                isLoading = false
            }
            
            try await SessionStore.createUser(withEmail: userEmail,
                                                           password: userPassword,
                                                           username: userName)
            
            canSubmit = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
