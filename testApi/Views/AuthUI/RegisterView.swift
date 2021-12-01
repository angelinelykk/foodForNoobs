//
//  RegisterView.swift
//  testApi
//
//  Created by Oleg Bezrukavnikov on 11/21/21.
//

import SwiftUI

struct RegisterView : View {
    @FocusState private var usernameFieldIsFocused: Bool
    @FocusState private var passwordFieldIsFocused: Bool
    
    @State var email: String = ""
    @State var username: String = ""
    @State var password: String = ""
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        NavigationView() {
            VStack {
                Spacer()
                AppTitleText()
                Spacer()
                Spacer()
                Spacer()
                Group {
                    TextField(text: $email) {
                        Text("Email")
                    }.onSubmit {
                        usernameFieldIsFocused = true
                    }.submitLabel(.next)
                        .padding()
                        .background(lightGreyColor)
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                    TextField(text: $username) {
                        Text("Username")
                    }.onSubmit {
                        passwordFieldIsFocused = true
                    }.submitLabel(.next).focused($usernameFieldIsFocused)
                        .padding()
                        .background(lightGreyColor)
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                    SecureField(text: $password) {
                        Text("Password")
                    }.submitLabel(.done).focused($passwordFieldIsFocused)
                        .padding()
                        .background(lightGreyColor)
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                    Button(action: {
                        RecipeAPI.shared.register(
                            username: username,
                            password: password,
                            email: email,
                            completion: { result in
                                if case .success = result {
                                    RecipeAPI.shared.login(
                                        username: username,
                                        password: password,
                                        completion: { result in
                                            if case .success = result {
                                                LoginState.shared.loggedIn = true
                                            } else {
                                            
                                            }
                                        }
                                    )
                                } else {
                                    
                                }
                            }
                        )
                    }) {
                       RegisterButtonContent()
                    }
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        SigninButtonContent()
                    }
                }
            }
            .padding(.all, 30)
        }.navigationBarHidden(true)
    }
}

#if DEBUG
struct RegisterView_Previews : PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
#endif

struct RegisterButtonContent : View {
    var body: some View {
        return Text("Register")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: UIScreen.main.bounds.size.width / 2, height: 50)
            .background(Color.green)
            .cornerRadius(15.0)
    }
}

struct SigninButtonContent : View {
    var body: some View {
        return Text("Have an account? Sign in")
            .padding()
    }
}
