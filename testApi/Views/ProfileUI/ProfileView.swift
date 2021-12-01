//
//  ProfileView.swift
//  testApi
//
//  Created by Oleg Bezrukavnikov on 11/30/21.
//

import Foundation
import SwiftUI

struct ProfileView : View {
    var body: some View {
        NavigationView() {
            VStack(alignment: .center) {
                Spacer()
                Button(action: {
                    LoginState.shared.loggedIn = false
                }) {
                    LogoutButtonContent()
                }
                Spacer()
            }
            .padding(.all, 30)
        }.navigationBarTitle("Profile", displayMode: .inline)
    }
}

struct LogoutButtonContent : View {
    var body: some View {
        return Text("Logout")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: UIScreen.main.bounds.size.width / 2, height: 50)
            .background(Color.gray)
            .cornerRadius(15.0)
    }
}
