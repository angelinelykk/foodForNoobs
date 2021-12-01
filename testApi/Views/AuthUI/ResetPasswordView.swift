//
//  ResetPasswordView.swift
//  testApi
//
//  Created by Oleg Bezrukavnikov on 11/21/21.
//

import SwiftUI

struct ResetPasswordView : View {
    @State var email: String = ""
    
    var body: some View {
        NavigationView() {
            VStack(alignment: .center) {
                Spacer()
                ForgotPasswordText()
                Text("Confirm your email and we'll send the instructions.").padding(.bottom, 20).fixedSize(horizontal: false, vertical: true)
                TextField(text: $email) {
                    Text("Email")
                }.submitLabel(.done)
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                Button(action: {print("Button tapped")}) {
                    ResetPasswordButtonContent()
                }
                Spacer()
            }
            .padding(.all, 30)
        }.navigationBarTitle("Forgot Password", displayMode: .inline)
    }
}

#if DEBUG
struct ResetPasswordView_Previews : PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
#endif

//struct FirstResponderTextField: UIViewRepresentable {
//    @Binding var text: String
//    let placeholder: String
//    class Coordinator: NSObject, UITextFieldDelegate {
//        @Binding var text: String
//        var becameFirstResponder = false
//        init(text: Binding<String>) {
//            self._text = text
//        }
//        func textFieldDidChangeSelection(_ textField: UITextField) {
//            text = textField.text ?? ""
//        }
//    }
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(text: $text)
//    }
//    func makeUIView(context: Context) -> some UIView {
//        let textField = UITextField()
//        textField.delegate = context.coordinator
//        textField.placeholder = placeholder
//        return textField
//    }
//    func updateUIView(_ uiView: UIViewType, context: Context) {
//        if !context.coordinator.becameFirstResponder {
//            uiView.becomeFirstResponder()
//            context.coordinator.becameFirstResponder = true
//        }
//    }
//}

struct ForgotPasswordText : View {
    var body: some View {
        return Text("Forgot your password?")
            .font(.title)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
            .padding(.bottom, 20)
    }
}

struct ResetPasswordButtonContent : View {
    var body: some View {
        return Text("Reset Password")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: UIScreen.main.bounds.size.width / 2, height: 50)
            .background(Color.green)
            .cornerRadius(15.0)
    }
}
