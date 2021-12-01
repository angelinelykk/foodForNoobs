//
//  LoginView.swift
//  testApi
//
//  Created by Oleg Bezrukavnikov on 11/21/21.
//

import SwiftUI

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)

struct LoginView : View {
    enum FocusedField {
        case username
        case password
    }
    
    @FocusState private var focusedField: FocusedField?
    
    @State var username: String = ""
    @State var password: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                AppTitleText()
                Spacer()
                Spacer()
                Spacer()
                TextField(text: $username) {
                    Text("Username")
                }.focused($focusedField, equals: .username)
                    .submitLabel(.next)
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                SecureField(text: $password) {
                    Text("Password")
                }.focused($focusedField, equals: .password)
                    .submitLabel(.done)
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                Button(action: {
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
                }) {
                   LoginButtonContent()
                }
                NavigationLink(destination: ResetPasswordView()) {
                    ForgotPassowrdButtonContent()
                }
                NavigationLink(destination: RegisterView()) {
                    SignupButtonContent()
                }
            }.onSubmit {
                if (focusedField == .username) {
                    focusedField = .password
                }
            }
            .padding(.all, 30)
        }
    }
}

#if DEBUG
struct LoginView_Previews : PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
#endif

struct AppTitleText : View {
    var body: some View {
        return Text("Food For Noobs")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
            .padding(.bottom, 20)
    }
}

struct LoginButtonContent : View {
    var body: some View {
        return Text("Login")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: UIScreen.main.bounds.size.width / 2, height: 50)
            .background(Color.green)
            .cornerRadius(15.0)
    }
}

struct ForgotPassowrdButtonContent : View {
    var body: some View {
        return Text("Forgot password")
            .padding()
    }
}

struct SignupButtonContent : View {
    var body: some View {
        return Text("Create an account")
    }
}
